import SwiftUI

struct ResultView: View {

    @State var selectedSegment: Segment?

    var company: Company

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
                        StockChart(stockSymbol: company.id)
                    }
                }
            }
        }
        .colorScheme(.light)
        .navigationTitle(company.name)
        .navigationBarTitleDisplayMode(.inline)
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

    // MARK: - Debug
    private func createDebug() -> some View {
        HStack {
            Text("#: \(company.hashScore) |")
            Text("@: \(company.arobaseScore) |")
            Text("news: \(company.newsScore) |")
         }
    }

}
