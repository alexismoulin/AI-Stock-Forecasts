import XCTest
@testable import AI_Stock_Forecasts

class YahooFinanceTests: XCTestCase {

    // MARK: - Helper functions

    func loadingBundle() -> [StockLog] {
        let bundle = Bundle(for: YahooFinanceTests.self)
        let data: Chart = bundle.decode(Chart.self, from: "YahooFinanceResultsMockup.json")
        let timeStamps = data.chart.result[0].timestamp
        let stockValues = data.chart.result[0].indicators.quote[0].close
        let volumes = data.chart.result[0].indicators.quote[0].volume
        var stockLogs: [StockLog] = []
        for (stockPrice, volume, timeStamp) in zip3(stockValues, volumes, timeStamps) {
            stockLogs.append(StockLog(
                price: stockPrice,
                volume: volume,
                date: Date(timeIntervalSince1970: TimeInterval(timeStamp))
            ))
        }
        return stockLogs
    }

    // MARK: - Tests

    func testDummyAPI() {
        let bundle: Bundle = Bundle(for: YahooFinanceTests.self)
        let data: Chart = bundle.decode(Chart.self, from: "YahooFinanceResultsMockup.json")
        let timestamps = data.chart.result[0].timestamp
        XCTAssertEqual(timestamps.count, 23)
        XCTAssertEqual(timestamps[15] - timestamps[14], 86400)
        let stockValues = data.chart.result[0].indicators.quote[0].close
        XCTAssertEqual(stockValues.count, 23)
        XCTAssertGreaterThan(stockValues[14], 123)
        let volumes = data.chart.result[0].indicators.quote[0].volume
        XCTAssertEqual(volumes.count, 23)
        XCTAssertGreaterThan(volumes[14], 1000000)
    }

    func testZip3() {
        let array1: [Int] = [1, 2, 3, 4, 5, 6, 7]
        let array2: [String] = ["One", "Two", "Three", "Four", "Five"]
        let array3: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        var zippedArray: [(Int, String, Double)] = []
        for (int, string, double) in zip3(array1, array2, array3) {
            zippedArray.append((int, string, double))
        }
        XCTAssertEqual(zippedArray.count, min(array1.count, array2.count, array3.count))
    }

    func testStockLogs() {
        var stockLogs: [StockLog] = loadingBundle()
        stockLogs = stockLogs.suffix(20)
        XCTAssertEqual(stockLogs.count, 20)
        XCTAssertEqual(stockLogs[10].price, 119.98999786376953)
        XCTAssertEqual(stockLogs[5].date, Date(timeIntervalSince1970: 1615559400))
        XCTAssertEqual(stockLogs[15].volume, 93958900)
    }

}
