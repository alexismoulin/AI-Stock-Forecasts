import XCTest
import NaturalLanguage
@testable import AI_Stock_Forecasts

class MLModelTests: XCTestCase {

    func testSentimentCommentsBaseModel() {
        // Setup
        let model1 = Model1()
        var positiveComments = [TextClassifier1Input]()
        var nagativeComments = [TextClassifier1Input]()
        let bundle = Bundle(for: MLModelTests.self)
        let data = bundle.decode([String: [String]].self, from: "MockupTweets.json")

        // Test for positive comments
        for comment in data["positive"]! {
            positiveComments.append(TextClassifier1Input(text: comment))
        }
        XCTAssertEqual(positiveComments.count, 5, "Got \(data.count) comments")

        let positiveResult: Int = model1.makePrediction1(with: positiveComments)
        XCTAssertGreaterThan(positiveResult, 0, "Positive comments - got a score of: \(positiveResult)")

        // Test for negative comments
        for comment in data["negative"]! {
            nagativeComments.append(TextClassifier1Input(text: comment))
        }
        XCTAssertEqual(nagativeComments.count, 5, "Got \(data.count) comments")
        let negativeResult: Int = model1.makePrediction1(with: nagativeComments)
        XCTAssertLessThan(negativeResult, 0, "Negative comments - got a score of: \(negativeResult)")
    }

    func testSentimentCommentsAppleModel() {
        // Setup
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        var positiveScore: Double = 0
        var negativeScore: Double = 0
        let bundle = Bundle(for: MLModelTests.self)
        let data = bundle.decode([String: [String]].self, from: "MockupTweets.json")

        // Test for positive comments
        for comment in data["positive"]! {
            tagger.string = comment
            let (sentiment, _) = tagger.tag(
                at: comment.startIndex,
                unit: .paragraph,
                scheme: .sentimentScore
            )
            let score: Double = Double(sentiment?.rawValue ?? "0") ?? 0
            // use squareroot to increase distribution STD
            if score >= 0 {
                positiveScore += score.squareRoot()
            } else {
                positiveScore -= (-score).squareRoot()
            }
        }
        XCTAssertGreaterThan(positiveScore, 0, "Positive comments - got a score of: \(positiveScore)")

        // Test for nagative comments
        for comment in data["negative"]! {
            tagger.string = comment
            let (sentiment, _) = tagger.tag(
                at: comment.startIndex,
                unit: .paragraph,
                scheme: .sentimentScore
            )
            let score: Double = Double(sentiment?.rawValue ?? "0") ?? 0
            // use squareroot to increase distribution STD
            if score >= 0 {
                negativeScore += score.squareRoot()
            } else {
                negativeScore -= (-score).squareRoot()
            }
        }
        XCTAssertLessThan(negativeScore, 0, "Negative comments - got a score of: \(negativeScore)")
    }
}
