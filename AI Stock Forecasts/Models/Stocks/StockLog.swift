import Foundation

struct StockLog {
    let price: Double
    let volume: Double
    let date: Date
    var millionVolume: String {
        String(format: "%.2f M", volume / 1000000)
    }
}

class StockData {

    static let testData: [StockLog] = [
        StockLog(price: 3.77, volume: 13000000, date: Date(timeIntervalSince1970: 1609282718)),
        StockLog(price: 3.01, volume: 12343444, date: Date(timeIntervalSince1970: 1607813915)),
        StockLog(price: 8.12, volume: 4553434, date: Date(timeIntervalSince1970: 1607381915)),
        StockLog(price: 2.22, volume: 34343422, date: Date(timeIntervalSince1970: 1606604315)),
        StockLog(price: 3.12, volume: 67867868, date: Date(timeIntervalSince1970: 1606604315)),
        StockLog(price: 9.01, volume: 67868688, date: Date(timeIntervalSince1970: 1605653915)),
        StockLog(price: 7.20, volume: 23232323, date: Date(timeIntervalSince1970: 1605653915)),
        StockLog(price: 4.76, volume: 76875474, date: Date(timeIntervalSince1970: 1604876315)),
        StockLog(price: 9.12, volume: 95464564, date: Date(timeIntervalSince1970: 1604876315)),
        StockLog(price: 6.01, volume: 453453454, date: Date(timeIntervalSince1970: 1604185115)),
        StockLog(price: 8.20, volume: 45345355, date: Date(timeIntervalSince1970: 1603234715)),
        StockLog(price: 4.76, volume: 3534566, date: Date(timeIntervalSince1970: 1603234715))
    ]

    func parse(results: Chart) -> [StockLog] {
        var stockLogs: [StockLog] = []

        let stockPrices: [Double] = results.chart.result[0].indicators.quote[0].close
        let volumes: [Double] = results.chart.result[0].indicators.quote[0].volume
        let timeStamps: [Int] = results.chart.result[0].timestamp
        // zip arrays as a safety in case they do not have the same size
        for (stockPrice, volume, timeStamp) in zip3(stockPrices, volumes, timeStamps) {
            stockLogs.append(StockLog(
                price: stockPrice,
                volume: volume,
                date: Date(timeIntervalSince1970: TimeInterval(timeStamp))
            ))
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
