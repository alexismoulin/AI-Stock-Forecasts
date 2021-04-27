import SwiftUI

struct StockHistoryView: View {

    let data: [StockLog]
    let currentDate: Date
    @State var selectedIndex: Int = 0

    init(data: [StockLog]) {
        self.data = data
        self.currentDate = data.map { $0.date }.max() ?? Date()
        if data.isEmpty {
            fatalError("No logs in StockHistoryView")
        } else {
            print("Passed !")
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            StockHistoryText(
                logs: data,
                curr: currentDate,
                selectedIndex: $selectedIndex
            )
            StockGraph(
                logs: data,
                curr: currentDate,
                selectedIndex: $selectedIndex,
                color: .blue
            )

        }.padding()
    }
}

struct StockHistoryViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            StockHistoryView(data: StockData.testData)
            StockHistoryView(data: StockData.testData)
                .colorScheme(.dark)
        }
    }
}
