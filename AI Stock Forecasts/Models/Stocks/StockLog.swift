import Foundation

struct StockLog {
    var price: Double
    var date: Date

    init(price: Double, date: Date) {
        self.price = price
        self.date = date
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

    func parse(results: Chart) -> [StockLog] {
        var stockLogs: [StockLog] = []
        let stockPrices: [Double] = results.chart.result[0].indicators.quote[0].close
        let timeStamps: [Int] = results.chart.result[0].timestamp
        let zipped: Zip2Sequence<[Double], [Int]> = zip(stockPrices, timeStamps)
        for element in zipped {
            stockLogs.append(StockLog(price: element.0, date: Date(timeIntervalSince1970: TimeInterval(element.1))))
        }
        return stockLogs
    }

    func getHistoricalData(stockSymbol: String, completion: @escaping ([StockLog]) -> Void) {

        let headers: [String: String] = [
            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com",
            "x-rapidapi-key": Keys.rapidAPIKey
        ]

        // swiftlint:disable:next line_length
        let url: URL = NSURL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/get-charts?region=US&symbol=\(stockSymbol)&interval=1d&range=1mo")! as URL

        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        var stockLogs: [StockLog] = []

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, _, error) -> Void in
            if error == nil {
                let decoder = JSONDecoder()
                if let safeData = data {
                    do {
                        let results = try decoder.decode(Chart.self, from: safeData)
                        stockLogs = self.parse(results: results)
                    } catch {
                        print("ERROR RapidAPI --->>> ", error.localizedDescription)
                    }
                }

            }
            completion(stockLogs)
        }
        dataTask.resume()
    }

}
