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

class StockTestData {
    static let testData: [StockLog] = [
        StockLog(price: 1.77, date: Date(timeIntervalSince1970: 1609282718)),
        StockLog(price: 3.01, date: Date(timeIntervalSince1970: 1607813915)),
        StockLog(price: 8.12, date: Date(timeIntervalSince1970: 1607381915)),
        StockLog(price: 2.22, date: Date(timeIntervalSince1970: 1606604315)),
        StockLog(price: 3.12, date: Date(timeIntervalSince1970: 1606604315)),
        StockLog(price: 9.01, date: Date(timeIntervalSince1970: 1605653915)),
        StockLog(price: 7.20, date: Date(timeIntervalSince1970: 1605653915)),
        StockLog(price: 4.76, date: Date(timeIntervalSince1970: 1604876315)),
        StockLog(price: 12.12, date: Date(timeIntervalSince1970: 1604876315)),
        StockLog(price: 6.01, date: Date(timeIntervalSince1970: 1604185115)),
        StockLog(price: 8.20, date: Date(timeIntervalSince1970: 1603234715)),
        StockLog(price: 4.76, date: Date(timeIntervalSince1970: 1603234715))
    ]
}
