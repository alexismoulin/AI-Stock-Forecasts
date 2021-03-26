import SwiftUI
import Charts

struct StockChart: View {

    var stockSymbol: String

    @State var stockPrices: [Double] = []

    func createBarChart(stocks: [Double]) -> some View {
        var stockEntries = [BarChartDataEntry]()
        for stockValue in 0..<stocks.count {
            stockEntries.append(BarChartDataEntry(x: Double(stockValue), y: stocks[stockValue]))
        }
        return Bar(entries: stockEntries)
    }

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
            if stockPrices.isEmpty {
                ProgressView("loading data...")
            } else {
                createBarChart(stocks: stockPrices).frame(height: 200)
            }
        }.onAppear { getHistoricalData(stockSymbol: stockSymbol) { results in
            stockPrices = results.map { $0.value }
        }

        }
    }
}
