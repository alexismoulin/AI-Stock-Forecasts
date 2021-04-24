import XCTest
@testable import AI_Stock_Forecasts

class YahooFinanceTests: XCTestCase {

    func testDummyAPI() throws {
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
}
