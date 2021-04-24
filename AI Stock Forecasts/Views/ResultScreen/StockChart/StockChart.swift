import SwiftUI
import Charts

struct StockChart: View {

    // MARK: - Properties

    var stockSymbol: String
    let stockData = StockData()
    @State var stockPrices: [Double] = []
    @State var stockLogs: [StockLog] = []

    // MARK: - Component functions

    func createBarChart(stocks: [Double]) -> some View {
        var stockEntries = [BarChartDataEntry]()
        for stockValue in 0..<stocks.count {
            stockEntries.append(BarChartDataEntry(x: Double(stockValue), y: stocks[stockValue]))
        }
        return Bar(entries: stockEntries)
    }

    func createStockGraph(stockLogs: [StockLog]) -> some View {
        StockHistoryView(data: stockLogs)
    }

    // MARK: - body

    var body: some View {
        return VStack {
            Text("Daily stock chart for the last 20 days")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 5)

            HStack(alignment: .center, spacing: 0) {
                Text("Current stock price for ")
                    .font(.subheadline)
                Text("\(stockSymbol)")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                if !stockPrices.isEmpty {
                    let roundedPrice = String(format: "%.2f", stockPrices.last!)
                    Text(": $\(roundedPrice)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                } else {
                    Text("...")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
            }
            if stockLogs.count < 12 {
                ProgressView("loading data...")
            } else {
                createBarChart(stocks: stockPrices).frame(height: 200)
                createStockGraph(stockLogs: stockLogs)
            }
        }.onAppear { stockData.getHistoricalData(stockSymbol: stockSymbol) { results in
            stockPrices = results.map { $0.value }
            stockLogs = results.map { StockLog(dataPoint: $0) }.suffix(12)
            print("----------- Printing stock logs -----------")
            print(stockLogs)
            print("------------- End of logs -----------------")
        }

        }
    }
}
