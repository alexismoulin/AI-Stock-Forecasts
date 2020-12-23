import Foundation
import CoreML

struct Model1 {
    
    let modelArobase = try! TextClassifier1(configuration: MLModelConfiguration())
    
    func makePrediction1(with tweets: [TextClassifier1Input]) -> Int {
        do {
            let predictions = try self.modelArobase.predictions(inputs: tweets)
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
    
}

struct Model2 {
    
    let modelHash = try! TextClassifier2(configuration: MLModelConfiguration())
    
    func makePrediction2(with tweets: [TextClassifier2Input]) -> Int {
        do {
            let predictions = try self.modelHash.predictions(inputs: tweets)
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
}
