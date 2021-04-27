import SwiftUI
import CoreHaptics

struct ResultView: View {

    // MARK: - Properties

    let stockData = StockData()
    var company: Company
    @State var selectedSegment: Segment?
    @State private var engine = try? CHHapticEngine()
    @State var stockLogs: [StockLog] = []

    // MARK: - Screen Body

    var body: some View {
        GeometryReader { geometry in
            let circleRadius = geometry.size.height / 2.0
            ZStack {
                Color.background.edgesIgnoringSafeArea(.vertical)
                ScrollView {
                    VStack(alignment: .center) {
                        SectionTitle(
                            title: "Stock Forecast Score",
                            subTitle: "Score based on company sentiment analysis"
                        )
                        createCircleControl(radius: circleRadius)
                        createDescription()
                        Divider()
                        HStack(alignment: .center, spacing: 0) {
                            Text("Daily stock price for ")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("\(company.id)")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                        if stockLogs.count < 12 {
                            ProgressView("loading data...")
                        } else {
                            StockHistoryView(data: stockLogs)
                        }
                    }
                }
            }
        }
        // .colorScheme(.light)
        .navigationTitle(company.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            performHaptics()
            stockData.getHistoricalData(stockSymbol: company.id) { results in
                stockLogs = results.suffix(12)
                print("----------- Printing stock logs -----------")
                print(stockLogs)
                print("------------- End of logs -----------------")
            }
        }
    }

    // MARK: - Components

    private func createDescription() -> some View {
        return Group {
            Text(selectedSegment?.title ?? "")
                .font(.headline)
                .fontWeight(.semibold)
                .fixedSize(horizontal: false, vertical: true)
            Group {
                Text(selectedSegment?.description ?? "")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .lineLimit(3)
        }
    }

    private func createCircleControl(radius: CGFloat) -> some View {
        // let totalBalance: Double = 200
        let segments: [Segment] = [
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

        let circleControl = CircleControl(segments: segments, selectedSegment: $selectedSegment, company: company)

        return circleControl
            .frame(width: radius, height: radius)
            .padding(16.0)
    }

    // MARK: - Helper functions
    func performHaptics() {
        do {
            try engine?.start()
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
            let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

            let parameter = CHHapticParameterCurve(
                parameterID: .hapticIntensityControl,
                controlPoints: [start, end],
                relativeTime: 0
            )
            let event1 = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: 0
            )

            let event2 = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [sharpness, intensity],
                relativeTime: 0.125,
                duration: 1
            )

            let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Haptics failed: \(error.localizedDescription)")
        }
    }

}
