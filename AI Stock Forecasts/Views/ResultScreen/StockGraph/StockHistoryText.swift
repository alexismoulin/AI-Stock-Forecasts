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
        dateFormatter.string(from: logs.first?.date ?? Date())
    }

    var endDate: String {
        dateFormatter.string(from: logs.last?.date ?? Date())
    }

    // MARK: - Custom init

    init(logs: [StockLog], curr: Date, selectedIndex: Binding<Int>) {
        self._selectedIndex = selectedIndex
        self.curr = curr
        self.logs = logs.sorted { $0.date < $1.date }
    }

    // MARK: - body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Period: \(startDate) - \(endDate)".uppercased())
                .font(Font.body.weight(.heavy))

            HStack(spacing: 12) {

                VStack(alignment: .leading, spacing: 4) {
                    Text("Date")
                        .font(.caption)
                        .foregroundColor(Color.black.opacity(0.5))
                    Text(dateFormatter.string(from: logs[selectedIndex].date))
                        .font(Font.system(size: 20, weight: .medium, design: .default))
                }

                Color.gray
                    .opacity(0.5)
                    .frame(width: 1, height: 30, alignment: .center)

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
                Text("LAST \(logs.count) WORKING DAYS")
                    .font(Font.caption.weight(.heavy))
                    .foregroundColor(Color.black.opacity(0.7))
            }.padding(.top, 10)
        }
    }
}
