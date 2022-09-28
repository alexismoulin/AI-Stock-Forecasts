import Foundation

enum FetchType {
    case arobase, hash
}

class Networking: ObservableObject {

    @Published var noInternet: Bool = false

    let swifter = Swifter(consumerKey: Keys.twitterKey, consumerSecret: Keys.twitterSecretKey)

    // completion Handler functions

    func fetchTweets(company: Company,
                     using fetchType: FetchType,
                     numberOfCompanies: Double=1,
                     completion: @escaping (Company.Tags) -> Void) {
        let tags = Company.Tags()
        swifter.searchTweet(
            using: fetchType == .arobase ? company.arobase : company.hash,
            lang: "en",
            count: 60,
            tweetMode: .extended,
            success: { (results, _) in
                for count in 0...59 {
                    if let tweet = results[count]["full_text"].string {
                        // print(tweet)
                        let cleanedTweet = TextProcessing.processTweet(tweet: tweet)
                        TextProcessing.tagText(
                            text: cleanedTweet,
                            source: fetchType == .arobase ? .twitterArobase : .twitterHash,
                            tags: tags
                        )
                        TextProcessing.mlText(
                            text: cleanedTweet,
                            type: fetchType,
                            source: fetchType == .arobase ? .twitterArobase : .twitterHash,
                            tags: tags
                        )
                    }
                }
                completion(tags)
            },
            failure: { error in
                if error.localizedDescription == "The Internet connection appears to be offline." {
                    self.noInternet = true
                } else {
                    print("There was an error with the Twitter API: --> ", error)
                }
                completion(tags)
            }
        )
    }

    func fetchTweetMessages(company: Company, using fetchType: FetchType) async -> Company.Tags {
        await withCheckedContinuation { continuation in
            fetchTweets(company: company, using: fetchType) { messages in
                continuation.resume(returning: messages)
            }
        }
    }

    func fetchData(company: Company, completion: @escaping (Company.Tags) -> Void) {
        let key = Keys.newsApiKey
        let tags = Company.Tags()
        let urlName = company.arobase.dropFirst()
        print(urlName)
        let urlString = "https://newsapi.org/v2/everything?language=en&q=\(urlName)&apiKey=\(key)"
        guard let url = URL(string: urlString) else {
            print("Error URL News API")
            completion(tags)
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, _, error) in
            if error == nil {
                let decoder = JSONDecoder()
                if let safeData = data {
                    do {
                        let results = try decoder.decode(News.self, from: safeData)
                        print("News \(results.articles.count)")
                        for article in results.articles {
                            print(article.title)
                            TextProcessing.tagText(text: article.title, source: .newsAPI, tags: tags)
                            TextProcessing.mlText(text: article.title, type: .arobase, source: .newsAPI, tags: tags)
                        }
                        completion(tags)
                    } catch {
                        print("ERROR NEWS API --->>> ", error.localizedDescription)
                        completion(tags)
                    }
                }
            }
        }
        task.resume()
    }

    func fetchNewsMessages(company: Company) async -> Company.Tags {
        await withCheckedContinuation { continuation in
            fetchData(company: company) { messages in
                continuation.resume(returning: messages)
            }
        }
    }

}
