import Foundation

struct YahooFinance {
    
    static func getHistoricalData(stockSymbol: String, completion: @escaping ([Double]) -> Void) {
        
        let headers = [
            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com",
            "x-rapidapi-key": Keys.rapidAPIKey
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/get-charts?region=US&symbol=\(stockSymbol)&interval=1d&range=1mo")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        var stockPriceArray: [Double] = [0.0, 0.0, 0.0]
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if (error == nil) {
                let decoder = JSONDecoder()
                if let safeData = data {
                    do {
                        let results = try decoder.decode(Chart.self, from: safeData)
                        let stockPrices = results.chart.result[0].indicators.quote[0].close
                        stockPriceArray = stockPrices
                    } catch {
                        print("ERROR RapidAPI --->>> ", error.localizedDescription)
                    }
                }
                
            }
            completion(stockPriceArray)
        }
        dataTask.resume()
    }
    
}

struct Close: Codable {
    let close: [Double]
}

struct QuoteInformations: Codable {
    let quote: [Close]
}

struct Indicators: Codable {
    let indicators: QuoteInformations
}

struct ResultInformations: Codable {
    let result: [Indicators]
}

struct Chart: Codable {
    let chart: ResultInformations
}
