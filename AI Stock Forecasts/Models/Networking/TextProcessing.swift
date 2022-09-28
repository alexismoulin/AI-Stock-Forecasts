import Foundation
import NaturalLanguage

struct TextProcessing {

    static let model1 = Model1()
    static let model2 = Model2()

    static func tagText(text: String, source: Source, tags: Company.Tags) {
        guard let score = calculateSentimentScore(text: text) else { return }
        addTag(score: score, text: text, source: source, tags: tags)
    }

    static func mlText(text: String, type: FetchType, source: Source, tags: Company.Tags) {
        switch type {
        case .arobase:
            guard let score = calculateModel1Score(text: text) else { return }
            addTag(score: score, text: text, source: source, tags: tags)
        case .hash:
            guard let score = calculateModel2Score(text: text) else { return }
            addTag(score: score, text: text, source: source, tags: tags)
        }
    }

    static func calculateSentimentScore(text: String) -> Double? {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        guard let result = sentiment?.rawValue else { return nil }
        guard let score = Double(result) else { return nil }
        return score
    }

    static func calculateModel1Score(text: String) -> Double? {
        let input1 = TextClassifier1Input(text: text)
        guard let score1 = model1.makePrediction1(with: input1) else { return nil }
        return Double(score1)
    }

    static func calculateModel2Score(text: String) -> Double? {
        let input2 = TextClassifier2Input(text: text)
        guard let score2 = model2.makePrediction2(with: input2) else { return nil }
        return Double(score2)
    }

    static func addTag(score: Double, text: String, source: Source, tags: Company.Tags) {
        if score > 0.25 {
            tags.buyTags.append(Company.Tag(source: source, text: text))
        } else if score < -0.25 {
            tags.sellTags.append(Company.Tag(source: source, text: text))
        } else {
            tags.holdTags.append(Company.Tag(source: source, text: text))
        }
    }

    static func processTweet(tweet: String) -> String {
        var cleanedString: String
        cleanedString = tweet

        // Remove HTML special entities (e.g. &amp;)
        cleanedString.clean(regex: "\\&\\w*;")
        // Convert @username to AT_USER
        cleanedString.clean(regex: "@[^\\s]+")
        // Remove tickers
        cleanedString.clean(regex: "\\$\\w*")
        // To lowercase
        cleanedString.lowercasing()
        // Remove hyperlinks
        cleanedString.clean(regex: "https?:\\/\\/.*\\/\\w*")
        // Remove hashtags
        cleanedString.clean(regex: "#\\w*")
        // Remove whitespace (including new line characters)
        cleanedString.clean(regex: "\\s\\s+", with: " ")
        // Remove rt at the start of a string
        cleanedString.removeRT()
        // Remove Emojis
        cleanedString.removeEmojis()

        return cleanedString
    }
}
