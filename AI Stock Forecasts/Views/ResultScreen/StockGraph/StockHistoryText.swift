import SwiftUI

struct StockHistoryText: View {

    // MARK: - Properties

    var logs: [StockLog]
    var curr: Date
    @Binding var selectedIndex: Int

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }

    var startDate: String {
        dateFormatter.string(from: logs[selectedIndex].date.addingTimeInterval(-604800))
    }

    var endDate: String {
        dateFormatter.string(from: logs[selectedIndex].date)
    }

    // MARK: - Custom init

    init(logs: [StockLog], curr: Date, selectedIndex: Binding<Int>) {
        self._selectedIndex = selectedIndex
        self.curr = curr
        // let curr = Date(timeIntervalSince1970: 1609282718)
        let sortedLogs = logs.sorted { $0.date > $1.date } // Sort the logs in chronological order

        var mergedLogs: [StockLog] = []

        for day in 0..<12 {

            var weekLog: StockLog = StockLog(price: 0, date: Date())

            for log in sortedLogs {
                if log.date.distance(
                    to: curr.addingTimeInterval(TimeInterval(-604800 * day))) < 604800 &&
                    log.date < curr.addingTimeInterval(TimeInterval(-604800 * day)
                    ) {
                    weekLog.price += log.price
                }
            }

            mergedLogs.insert(weekLog, at: 0)
        }

        self.logs = mergedLogs
    }

    // MARK: - body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(startDate) - \(endDate)".uppercased())
                .font(Font.body.weight(.heavy))

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Stock Price")
                        .font(.caption)
                        .foregroundColor(Color.black.opacity(0.5))
                    Text(String(format: "%.2f $", logs[selectedIndex].price))
                        .font(Font.system(size: 20, weight: .medium, design: .default))
                }

                Color.gray
                    .opacity(0.5)
                    .frame(width: 1, height: 30, alignment: .center)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("LAST \(logs.count) WEEKS")
                    .font(Font.caption.weight(.heavy))
                    .foregroundColor(Color.black.opacity(0.7))
            }.padding(.top, 10)
        }
    }
}
