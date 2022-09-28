import SwiftUI

struct StockCard: View {

    // MARK: - Properties

    let data: [StockLog]
    let currentDate: Date
    let stockTitle: String
    @State var selectedIndex: Int = 11

    var safeIndex: Int {
        if selectedIndex < 0 {
            return 0
        } else if selectedIndex > 11 {
            return 11
        } else {
            return selectedIndex
        }
    }

    var calculateVariation: Double {
        if safeIndex == 0 {
            return 0
        } else {
            let delta = data[safeIndex].price - data[safeIndex - 1].price
            return delta
        }
    }

    // MARK: - Custom init

    init(stockTitle: String, data: [StockLog]) {
        self.stockTitle = stockTitle
        self.data = data
        self.currentDate = data.map { $0.date }.max() ?? Date()
        if data.isEmpty {
            fatalError("No logs in StockHistoryView")
        } else {
            print("Passed !")
        }
    }

    // MARK: - body

    var body: some View {
        VStack(spacing: 16) {
            stockHistoryTitle
            StockHistoryText(
                logs: data,
                curr: currentDate,
                selectedIndex: $selectedIndex
            )
            StockHistoryGraph(
                logs: data,
                curr: currentDate,
                selectedIndex: $selectedIndex,
                color: .blue
            )

        }.cardStyle(height: 400)
    }

    // MARK: - Custom components

    @ViewBuilder
    func variationInfo() -> some View {
        if calculateVariation > 0 {
            HStack {
                Image(systemName: "arrowtriangle.up.fill")
                Text(
                    "(\(String(format: "%.2f $", calculateVariation)) |"
                        + " \(String(format: "%.2f", 100 * calculateVariation / data[safeIndex].price)) %)"
                )
            }
            .font(.headline)
            .foregroundColor(.green.opacity(0.8))
        } else if calculateVariation < 0 {
            HStack {
                Image(systemName: "arrowtriangle.down.fill")
                Text(
                    "(\(String(format: "%.2f $", calculateVariation)) |"
                        + " \(String(format: "%.2f", 100 * calculateVariation / data[safeIndex].price)) %)"
                )
            }
            .font(.headline)
            .foregroundColor(.red.opacity(0.8))
        } else {
            Text("(0.00 $ | 0.00 %)")
                .font(.headline)
                .foregroundColor(.yellow.opacity(0.8))
        }
    }

    var stockHistoryTitle: some View {
        VStack {
            HStack {
                Text("Daily stock price for ")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(stockTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            variationInfo()
        }
    }

}

struct StockCardPreview: PreviewProvider {
    static var previews: some View {
        Group {
            StockCard(stockTitle: "AAPL", data: StockData.testData)
            StockCard(stockTitle: "AAPL", data: StockData.testData)
                .preferredColorScheme(.dark)
                .colorScheme(.dark)
        }
    }
}
