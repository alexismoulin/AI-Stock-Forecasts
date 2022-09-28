import Foundation

struct News: Decodable {
    struct Article: Decodable {
        let title: String
    }
    // 20 items
    let articles: [Article]

    static let emptyNews = News(articles: [])

    static func fetchNews(company: Company) async throws -> News {
        let key = Keys.newsApiKey
        let stringURL = "https://newsapi.org/v2/everything?language=en&q=\(company)&apiKey=\(key)"
        guard let url = URL(string: stringURL) else { return News.emptyNews }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(News.self, from: data)
    }
}
