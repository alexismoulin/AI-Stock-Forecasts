import Foundation
import CoreML

struct Model1 {

    let optionalModelArobase: TextClassifier1? = try? TextClassifier1(configuration: MLModelConfiguration())

    func makePrediction1(with tweet: TextClassifier1Input) -> Int? {
        guard let modelArobase = optionalModelArobase else { return nil }
        guard let prediction = try? modelArobase.prediction(input: tweet) else { return nil }
        switch prediction.label {
        case "pos":
            return 1
        case "neg":
            return -1
        default:
            return nil
        }
    }

    func makePrediction1(with tweets: [TextClassifier1Input]) -> Int {
        if let modelArobase = optionalModelArobase {
            do {
                let predictions = try modelArobase.predictions(inputs: tweets)
                var sentimentScore: Int = 0
                for pred in predictions {
                    switch pred.label {
                    case "pos":
                        sentimentScore += 1
                    case "neg":
                        sentimentScore -= 1
                    default:
                        break
                    }
                }
                return sentimentScore
            } catch {
                print("There was an error with the ML model: --> ", error)
                return 0
            }
        }
        print("Failed unwrapping optionalModelArobase")
        return 0
    }
}

struct Model2 {

    let optionalModelHash: TextClassifier2? = try? TextClassifier2(configuration: MLModelConfiguration())

    func makePrediction2(with tweet: TextClassifier2Input) -> Int? {
        guard let modelHash = optionalModelHash else { return nil }
        guard let prediction = try? modelHash.prediction(input: tweet) else { return nil }
        switch prediction.label {
        case "positive":
            return 1
        case "neutral":
            return 0
        case "negative":
            return -1
        default:
            return nil
        }
    }

    func makePrediction2(with tweets: [TextClassifier2Input]) -> Int {
        if let modelHash = optionalModelHash {
            do {
                let predictions = try modelHash.predictions(inputs: tweets)
                var sentimentScore: Int = 0
                for pred in predictions {
                    switch pred.label {
                    case "positive":
                        sentimentScore += 1
                    case "negative":
                        sentimentScore -= 1
                    default:
                        break
                    }
                }
                return sentimentScore
            } catch {
                print("There was an error with the ML model: --> ", error)
                return 0
            }
        }
        print("Failed unwrapping optionalModelHash")
        return 0
    }
}
