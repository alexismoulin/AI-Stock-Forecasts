import Foundation

enum SectorEnum: String, CaseIterable {
    case industrials
    case healthcare
    case technology
    case telecomMedia = "telecom-media"
    case goods
    case energy
    case financials
    case all
}

enum Source: String {
    case twitterArobase, twitterHash, newsAPI
}

enum SearchType: String, CaseIterable {
    case standard, custo, all
}
