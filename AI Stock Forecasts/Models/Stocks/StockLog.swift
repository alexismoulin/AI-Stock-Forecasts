import Foundation

struct StockLog {
    var price: Double
    var date: Date

    init(price: Double, date: Date) {
        self.price = price
        self.date = date
    }

    init(dataPoint: DataPoint) {
        self.price = dataPoint.value
        self.date = Date(timeIntervalSince1970: TimeInterval(dataPoint.day))
    }
}

class StockData {

    static let testData: [StockLog] = [
        StockLog(price: 3.77, date: Date(timeIntervalSince1970: 1609282718)),
        StockLog(price: 3.01, date: Date(timeIntervalSince1970: 1607813915)),
        StockLog(price: 8.12, date: Date(timeIntervalSince1970: 1607381915)),
        StockLog(price: 2.22, date: Date(timeIntervalSince1970: 1606604315)),
        StockLog(price: 3.12, date: Date(timeIntervalSince1970: 1606604315)),
        StockLog(price: 9.01, date: Date(timeIntervalSince1970: 1605653915)),
        StockLog(price: 7.20, date: Date(timeIntervalSince1970: 1605653915)),
        StockLog(price: 4.76, date: Date(timeIntervalSince1970: 1604876315)),
        StockLog(price: 9.12, date: Date(timeIntervalSince1970: 1604876315)),
        StockLog(price: 6.01, date: Date(timeIntervalSince1970: 1604185115)),
        StockLog(price: 8.20, date: Date(timeIntervalSince1970: 1603234715)),
        StockLog(price: 4.76, date: Date(timeIntervalSince1970: 1603234715))
    ]

    func formatTimeStamps(timeStampArray: [Double]) -> [Int] {
        let calendar = Calendar.current
        let dates: [Date] = timeStampArray.map {  Date(timeIntervalSince1970: $0) }
        let days: [Int] = dates.map { calendar.component(.day, from: $0) }
        return days
    }

    func createDataPointArray(stockPriceArray: [Double], daysArray: [Int]) -> [DataPoint] {
        var dataPoints: [DataPoint] = []
        let zipped: Zip2Sequence<[Double], [Int]> = zip(stockPriceArray, daysArray)
        for element in zipped {
            dataPoints.append(DataPoint(value: element.0, day: element.1))
        }
        return dataPoints
    }

    func parse(results: Chart) -> [DataPoint] {
        let rawStockPrices: [Double] = results.chart.result[0].indicators.quote[0].close
        let timeStamps: [Double] = results.chart.result[0].timestamp
        // let roundedStockPrices: [Double] = roundStockPrices(stockPriceArray: stockPrices)
        let dates: [Int] = formatTimeStamps(timeStampArray: timeStamps)

        let dataPoints: [DataPoint] = createDataPointArray(stockPriceArray: rawStockPrices, daysArray: dates)
        return dataPoints
    }

    func getHistoricalData(stockSymbol: String, completion: @escaping ([DataPoint]) -> Void) {

        let headers: [String: String] = [
            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com",
            "x-rapidapi-key": Keys.rapidAPIKey
        ]

        // swiftlint:disable:next line_length
        let url: URL = NSURL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/get-charts?region=US&symbol=\(stockSymbol)&interval=1d&range=1mo")! as URL

        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        var dataPoints: [DataPoint] = []

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, _, error) -> Void in
            if error == nil {
                let decoder = JSONDecoder()
                if let safeData = data {
                    do {
                        let results = try decoder.decode(Chart.self, from: safeData)
                        dataPoints = self.parse(results: results)
                    } catch {
                        print("ERROR RapidAPI --->>> ", error.localizedDescription)
                    }
                }

            }
            completion(dataPoints)
        }
        dataTask.resume()
    }

}
