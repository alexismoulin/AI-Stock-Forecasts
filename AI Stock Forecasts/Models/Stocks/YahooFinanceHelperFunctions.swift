import Foundation

func roundStockPrices(stockPriceArray: [Double]) -> [Double] {
    stockPriceArray.map { (Double(String(format: "%.2f", $0)) ?? 0) }
}

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
        dataPoints.append(DataPoint(value: element.0, title: element.1))
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
                    dataPoints = parse(results: results)
                } catch {
                    print("ERROR RapidAPI --->>> ", error.localizedDescription)
                }
            }

        }
        completion(dataPoints)
    }
    dataTask.resume()
}
