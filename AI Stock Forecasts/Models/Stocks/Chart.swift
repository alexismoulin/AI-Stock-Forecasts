import Foundation

struct Close: Codable {
    let close: [Double]
    let volume: [Double]
}

struct QuoteInformations: Codable {
    let quote: [Close]
}

struct Indicators: Codable {
    let indicators: QuoteInformations
    let timestamp: [Int]
}

struct ResultInformations: Codable {
    let result: [Indicators]
}

struct Chart: Codable {
    let chart: ResultInformations
}
