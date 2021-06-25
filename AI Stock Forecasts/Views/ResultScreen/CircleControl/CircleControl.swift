import SwiftUI

struct CircleControl: View {

    // MARK: - Properties

    let totalBalance: Double = 200
    let lineWidth: CGFloat = 44.0
    let segments: [Segment]
    let company: Company
    let startAngle = Angle(radians: -.pi / 2)

    var endAngle: Angle {
        Angle(radians: Double(shiftedScore / totalBalance * 2 * .pi - .pi / 2.0))
    }

    var color: Color {
        currentSegment()?.color ?? .white
    }

    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [color.opacity(0.6), color]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    @State private var showDetails: Bool = false
    @State private var shiftedScore: Double = 0
    @Binding var selectedSegment: Segment?

    // MARK: - body

    var body: some View {
        GeometryReader { geometry in
            createBody(size: geometry.size)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2)) {
                shiftedScore = company.totalScore + 100
                selectedSegment = currentSegment()
            }
        }
        .sheet(isPresented: $showDetails) {
            DetailView(company: company, showDetails: $showDetails)
        }
    }

    private func createBody(size: CGSize) -> some View {
        let controlRadius: CGFloat = size.width / 2.0

        return ZStack {
            createOuterCircle(radius: controlRadius)
            createInnerCircle(radius: controlRadius)
            AnimatableProgressArc(
                radius: controlRadius,
                lineWidth: lineWidth,
                startAngle: startAngle,
                endAngle: endAngle
            ).fill(color)
            createTopArc(radius: controlRadius)
            createPoints(radius: controlRadius)
            Group {
                AnimatableControlPointExterior(
                    radius: controlRadius,
                    lineWidth: lineWidth,
                    startAngle: startAngle,
                    endAngle: endAngle
                ).foregroundColor(.pickerColor)
                AnimatableControlPointInterior(
                    radius: controlRadius,
                    lineWidth: lineWidth,
                    startAngle: startAngle,
                    endAngle: endAngle
                ).foregroundColor(color)
            }
            createCurrentValueText(radius: controlRadius)
        }
    }

    // MARK: - Component functions

    private func createOuterCircle(radius: CGFloat) -> some View {
        let diametr: CGFloat = radius * 2.0 - 4.0

        return Group {
            Circle().fill(Color.pickerColor)
            Circle().fill(Color.controlFill)
                .frame(width: diametr, height: diametr)
        }
    }

    private func createInnerCircle(radius: CGFloat) -> some View {
        let diametr = radius * 2.0 - lineWidth * 2.0
        let innerDiametr = diametr - 4.0

        return Group {
            Circle()
                .fill(Color.pickerColor)
                .frame(width: diametr, height: diametr)

            Circle()
                .fill(Color.background)
                .frame(width: innerDiametr, height: innerDiametr)
        }
    }

    private func createTopArc(radius: CGFloat) -> some View {
        let center = CGPoint(x: radius, y: lineWidth / 2.0 + 1.0)
        let rect = CGRect(
            x: radius - lineWidth / 2.0,
            y: 2.0,
            width: lineWidth,
            height: lineWidth - 2.0)

        return Group {
            Path { path in
                path.addEllipse(in: rect)
            }.foregroundColor(Color.controlFill)

            Path { path in
                path.addArc(
                    center: center,
                    radius: lineWidth / 2.0,
                    startAngle: .radians(-.pi / 2.0),
                    endAngle: .radians(.pi / 2.0),
                    clockwise: false)
                path = path.strokedPath(.init(lineWidth: 2.0))
            }.foregroundColor(.pickerColor)
        }
    }

    private func createPoints(radius: CGFloat) -> some View {
        return Group {
            ForEach(0..<segments.count) { index in
                self.createPoint(valuePosition: self.segments[index].amount, radius: radius)
            }
            createPoint(valuePosition: totalBalance, radius: radius)
        }
    }

    private func createPoint(valuePosition: Double, radius: CGFloat) -> some View {
        let pointWidth: CGFloat = 16.0
        let angle = CGFloat(valuePosition / totalBalance * 2 * .pi - .pi / 2.0)
        let center = CGPoint(x: radius, y: radius)
        let radius = radius - lineWidth / 2.0 - 1.0
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        let pointCenter = CGPoint(x: x, y: y)
        let rect = CGRect(
            x: pointCenter.x - pointWidth / 2.0,
            y: pointCenter.y - pointWidth / 2.0,
            width: pointWidth,
            height: pointWidth)

        return Path { path in
            path.addEllipse(in: rect)
        }.foregroundColor(.point)
    }

    private func createCurrentValueText(radius: CGFloat) -> some View {
        let diametr = radius * 2.0 - lineWidth * 2.0 - 16.0
        return VStack {
            Text("Score: \(String(format: "%.0f", company.totalScore))")
                .font(Font.system(size: 40.0, weight: .bold, design: .rounded))
            DetailButton { showDetails = true }
        }
        .frame(width: diametr, height: 100.0, alignment: .center)
        .minimumScaleFactor(0.5)
    }

    // MARK: - Helper functions

    private func currentSegment() -> Segment? {
        return segments.last { $0.amount <= shiftedScore } ?? segments.first
    }

    private func nearestSegmentPoint(value: Double) -> Segment? {
        let magnetCoef = min(totalBalance * 0.025, 50.0)
        return segments.first { $0.amount < value + magnetCoef && $0.amount > value - magnetCoef }
    }
}

struct Segment: Equatable {

    let color: Color
    let amount: Double
    let title: String
    let description: String
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {

    static let segments: [Segment] = [
        Segment(
            color: Color.red.opacity(0.8),
            amount: 0,
            title: "Very Negative Outcome",
            description: "The company and the stock have very negative feedbacks - The value of the stock is likely to decrease in the near future"), // swiftlint:disable:this line_length
        Segment(
            color: Color.orange.opacity(0.8),
            amount: 40,
            title: "Slightly Negative Outcome",
            description: "The company and the stock have slightly negative feedbacks - The value of the stock may decrease slightly in the near future"), // swiftlint:disable:this line_length
        Segment(
            color: Color.yellow.opacity(0.8),
            amount: 80,
            title: "Stable Outcome",
            description: "The company and the stock have neutral feedbacks - The value of the stock is likely to stay stable in the near future"), // swiftlint:disable:this line_length
        Segment(
            color: Color.green.opacity(0.8),
            amount: 120,
            title: "Slightly Positive Outcome",
            description: "The company and the stock have slightly positive feedbacks - The value of the stock may increase slightly in the near future"), // swiftlint:disable:this line_length
        Segment(
            color: Color.blue.opacity(0.8),
            amount: 160,
            title: "Very Positive Outcome",
            description: "The company and the stock have very positive feedbacks - The value of the stock is likely to increase slightly in the near future") // swiftlint:disable:this line_length
    ]

    static var previews: some View {
        CircleControl(
            segments: Self.segments,
            company: CompaniesModel.example,
            selectedSegment: .constant(Self.segments[3])
        )
    }
}
