import XCTest
@testable import AI_Stock_Forecasts

class NewsAPITests: XCTestCase {

    func testDummyAPI() {
        let bundle: Bundle = Bundle(for: NewsAPITests.self)
        let data: News = bundle.decode(News.self, from: "NewsAPIMockup.json")
        let articles: [News.Article] = data.articles
        XCTAssertEqual(articles.count, 20)
        for article in articles {
            XCTAssertNotEqual(article.title, "")
        }
    }

}
