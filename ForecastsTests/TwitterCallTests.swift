import XCTest
import Swifter
@testable import AI_Stock_Forecasts

// Async code testing
/*
class TwitterCallTests: XCTestCase {

    func testFetchTweets() {
        let swifter = Swifter(consumerKey: Keys.twitterKey, consumerSecret: Keys.twitterSecretKey)
        let company: String = "@Apple"
        swifter.searchTweet(
            using: company,
            lang: "en",
            count: 50,
            tweetMode: .extended,
            success: { (results, _) in
                var tweets: [String] = []
                for count in 0...49 {
                    tweets.append(results[count]["full_test"].string ?? "")
                    XCTAssertEqual(tweets[count], "")
                }
            },
            failure: { error in
                print("There was an error with the Twitter API: --> ", error)
            }
        )
    }
}
 */
