import SwiftUI

struct StockHistoryText: View {

    // MARK: - Properties

    @Binding var selectedIndex: Int
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var logs: [StockLog]
    var curr: Date

    var safeIndex: Int {
        if selectedIndex < 0 {
            return 0
        } else if selectedIndex > 11 {
            return 11
        } else {
            return selectedIndex
        }
    }

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

    // MARK: - Component functions

    func createStockInfo(title: String, information: String) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(colorScheme == .light ? .black.opacity(0.5) : .gray)
                Text(information)
                    .font(Font.system(size: 20, weight: .medium, design: .default))
            }

            Color.gray
                .opacity(colorScheme == .light ? 0.5 : 0.8)
                .frame(width: 1, height: 30, alignment: .center)
        }
    }

    // MARK: - body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Period: \(startDate) - \(endDate)".uppercased())
                .font(Font.body.weight(.heavy))

            HStack(spacing: 12) {
                createStockInfo(title: "Date", information: dateFormatter.string(from: logs[safeIndex].date))
                createStockInfo(title: "Stock Price", information: String(format: "%.2f $", logs[safeIndex].price))
                createStockInfo(title: "Volume", information: logs[safeIndex].millionVolume)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("LAST \(logs.count) WORKING DAYS")
                    .font(Font.caption.weight(.heavy))
                    .foregroundColor(colorScheme == .light ? .black.opacity(0.7) : .gray)
            }.padding(.top, 10)
        }
    }
}
