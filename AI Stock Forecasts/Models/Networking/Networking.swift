import Foundation
import Swifter
import NaturalLanguage

struct Networking {

    let swifter = Swifter(consumerKey: Keys.twitterKey, consumerSecret: Keys.twitterSecretKey)
    let model1 = Model1()
    let model2 = Model2()

    func fetchTweets1(company: String, completion: @escaping (Int) -> Void) {
        // Get 60 tweets using @Company from Tweeter and score them with Model 1 trained on IMBD
        swifter.searchTweet(
            using: company,
            lang: "en",
            count: 60,
            tweetMode: .extended,
            success: { (results, _) in
                var tweets = [TextClassifier1Input]()
                for count in 0...59 {
                    if let tweet = results[count]["full_text"].string {
                        tweets.append(TextClassifier1Input(text: tweet))
                    }
                }
                let score = model1.makePrediction1(with: tweets)
                completion(score)
            },
            failure: { error in
                print("There was an error with the Twitter API: --> ", error)
                completion(0)
            }
        )
    }

    func fetchTweets2(company: String, completion: @escaping (Int) -> Void) {
        // Get 60 tweets using #StockSymbol from Tweeter and score them with Model 2 trained on financial tweets
        swifter.searchTweet(
            using: company,
            lang: "en",
            count: 60,
            tweetMode: .extended,
            success: { (results, _) in
                var tweets = [TextClassifier2Input]()
                for count in 0...59 {
                    if let tweet = results[count]["full_text"].string {
                        tweets.append(TextClassifier2Input(text: tweet))
                    }
                }
                let score = model2.makePrediction2(with: tweets)
                completion(score)
            },
            failure: { (error) in
                print("There was an error with the Twitter API: --> ", error)
                completion(0)
            }
        )
    }

    func fetchData(company: String, completion: @escaping (Int) -> Void) {
        // Get 20 news title from News-API and score them with NLTagger
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        var totalScore: Double = 0
        let key = Keys.newsApiKey
        if let url = URL(string: "https://newsapi.org/v2/everything?q=\(company)&apiKey=\(key)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, _, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(News.self, from: safeData)
                            // apply NLTagger for each article title
                            for article in results.articles {
                                tagger.string = article.title
                                let (sentiment, _) = tagger.tag(
                                    at: article.title.startIndex,
                                    unit: .paragraph,
                                    scheme: .sentimentScore
                                )
                                let score: Double = Double(sentiment?.rawValue ?? "0") ?? 0
                                // use squareroot to increase distribution STD
                                if score >= 0 {
                                    totalScore += score.squareRoot()
                                } else {
                                    totalScore -= (-score).squareRoot()
                                }
                            }

                            completion(Int(totalScore))
                        } catch {
                            print("ERROR NEWS API --->>> ", error.localizedDescription)
                            completion(0)
                        }
                    }
                }
            }
            task.resume()
        }

    }
}
