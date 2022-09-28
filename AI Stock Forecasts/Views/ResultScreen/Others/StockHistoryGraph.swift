import SwiftUI

struct StockHistoryGraph: View {

    // MARK: - Properties

    let logs: [StockLog]
    let curr: Date

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var selectedIndex: Int
    @State private var lineOffset: CGFloat = 8 // Vertical line offset
    @State private var selectedXPos: CGFloat = 8 // User X touch location
    @State private var selectedYPos: CGFloat = 0 // User Y touch location
    @State private var isSelected: Bool = false // Is the user touching the graph
    @State private var color: Color

    var safeIndex: Int {
        if selectedIndex < 0 {
            return 0
        } else if selectedIndex > 11 {
            return 11
        } else {
            return selectedIndex
        }
    }

    // Used for scaling graph data
    var maxNum: CGFloat {
        CGFloat(logs.map { $0.price }.max() ?? 0)
    }
    var minNum: CGFloat {
        CGFloat(logs.map { $0.price }.min() ?? 0)
    }

    // MARK: - Custom init

    init(logs: [StockLog], curr: Date, selectedIndex: Binding<Int>, color: Color) {
        self._selectedIndex = selectedIndex
        self.curr = curr
        self.logs = logs.sorted { $0.date < $1.date }
        _color = State(wrappedValue: color)
    }

    // MARK: - body
    var body: some View {
        drawGrid(height: 150, color: .buttonColor)
            .opacity(colorScheme == .light ? 0.2 : 0.8)
            .overlay(drawActivityGradient(logs: logs))
            .overlay(drawActivityLine(logs: logs))
            .overlay(drawLogPoints(logs: logs))
            .overlay(addUserInteraction(logs: logs))
    }

    // MARK: - Component functions

    func drawGrid(height: CGFloat, color: Color) -> some View {
        VStack(spacing: 0) {
            color.frame(height: 1, alignment: .center)
            HStack(spacing: 0) {
                Color.clear
                    .frame(width: 8, height: height)
                ForEach(0..<11) { _ in
                    color.frame(width: 1, height: height, alignment: .center)
                    Spacer()

                }
                color.frame(width: 1, height: height, alignment: .center)
                Color.clear
                    .frame(width: 8, height: height)
            }
            color.frame(height: 1, alignment: .center)
        }
    }

    func drawActivityGradient(logs: [StockLog]) -> some View {
        LinearGradient(
            gradient: Gradient(colors: [color, .background]),
            startPoint: .top,
            endPoint: .bottom
        )
        .padding(.horizontal, 8)
        .padding(.bottom, 1)
        .opacity(0.8)
        .mask(
            GeometryReader { geo in
                Path { path in
                    let scale = geo.size.height / (maxNum - minNum)

                    // Week Index used for drawing (0-11)
                    var index: CGFloat = 0

                    // Move to the starting y-point on graph
                    path.move(to: CGPoint(
                                x: 8,
                                y: geo.size.height - ((CGFloat(logs[Int(index)].price) - minNum) * scale)
                    ))

                    // For each week draw line from previous week
                    for _ in logs {
                        if index != 0 {
                            path.addLine(to: CGPoint(
                                x: 8 + ((geo.size.width - 16) / 11) * index,
                                y: geo.size.height - ((CGFloat(logs[Int(index)].price) - minNum) * scale)
                            ))
                        }
                        index += 1
                    }

                    // Finally close the subpath off by looping around to the beginning point.
                    path.addLine(to: CGPoint(x: 8 + ((geo.size.width - 16) / 11) * (index - 1), y: geo.size.height))
                    path.addLine(to: CGPoint(x: 8, y: geo.size.height))
                    path.closeSubpath()

                }
            }
        )
    }

    func drawActivityLine(logs: [StockLog]) -> some View {
        GeometryReader { geo in
            Path { path in

                let scale = geo.size.height / (maxNum - minNum)

                // Week Index used for drawing (0-11)
                var index: CGFloat = 0

                path.move(to: CGPoint(
                    x: 8,
                    y: geo.size.height - ((CGFloat(logs[0].price) - minNum) * scale)
                ))

                for _ in logs {
                    if index != 0 {
                        path.addLine(to: CGPoint(
                            x: 8 + ((geo.size.width - 16) / 11) * index,
                            y: geo.size.height - ((CGFloat(logs[Int(index)].price) - minNum) * scale)
                        ))
                    }
                    index += 1
                }
            }
            .stroke(style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: 80,
                        dash: [],
                        dashPhase: 0)
            )
            .foregroundColor(color)
        }
    }

    func drawLogPoints(logs: [StockLog]) -> some View {
        GeometryReader { geo in

            let scale = geo.size.height / (maxNum - minNum)

            ForEach(logs.indices) { index in
                Circle()
                    .stroke(style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round,
                                lineJoin: .round,
                                miterLimit: 80,
                                dash: [],
                                dashPhase: 0)
                    )
                    .frame(width: 10, height: 10, alignment: .center)
                    .foregroundColor(color)
                    .background(Color.white)
                    .cornerRadius(5)
                    .offset(
                        x: 8 + ((geo.size.width - 16) / 11) * CGFloat(index) - 5,
                        y: (geo.size.height - ((CGFloat(logs[index].price) - minNum) * scale)) - 5
                    )
            }
        }
    }

    func createLineAndPointOverlay(scale: CGFloat, width: CGFloat) -> some View {
        color
            .frame(width: 2)
            .overlay(
                Circle()
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor(color)
                    .opacity(0.2)
                    .overlay(
                        Circle()
                            .fill()
                            .frame(width: 12, height: 12, alignment: .center)
                            .foregroundColor(color)
                    )
                    .offset(
                        x: 0,
                        y: isSelected ?
                            12 - (selectedYPos * scale) :
                            12 - ((CGFloat(logs[safeIndex].price) - minNum) * scale)
                    ),
                alignment: .bottom
            )
            .offset(x: isSelected ? lineOffset : 8 + ((width - 16) / 11) * CGFloat(safeIndex), y: 0)
            .animation(Animation.spring().speed(4), value: isSelected)
    }

    func addUserInteraction(logs: [StockLog]) -> some View {
        GeometryReader { geo in

            let scale = geo.size.height / (maxNum - minNum)

            ZStack(alignment: .leading) {
                createLineAndPointOverlay(scale: scale, width: geo.size.width)
                Color.white.opacity(0.1)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { touch in
                                let xPos = touch.location.x
                                self.isSelected = true
                                let index = (xPos - 8) / (((geo.size.width - 16) / 11))

                                if index > 0 && index < 11 {
                                    let majin = (logs[Int(index) + 1].price - logs[Int(index)].price)
                                    self.selectedYPos = CGFloat(majin) * index.truncatingRemainder(dividingBy: 1) +
                                        CGFloat(logs[Int(index)].price) - minNum
                                }

                                if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < 11 {
                                    self.selectedIndex = Int(index) + 1
                                } else {
                                    self.selectedIndex = Int(index)
                                }
                                self.selectedXPos = min(max(8, xPos), geo.size.width - 8)
                                self.lineOffset = min(max(8, xPos), geo.size.width - 8)
                            }

                            .onEnded { touch in
                                let xPos = touch.location.x
                                self.isSelected = false
                                let index = (xPos - 8) / (((geo.size.width - 16) / 11))

                                if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < 11 {
                                    self.selectedIndex = Int(index) + 1
                                } else {
                                    self.selectedIndex = Int(index)
                                }
                            }
                    )
            }

        }
    }

}
