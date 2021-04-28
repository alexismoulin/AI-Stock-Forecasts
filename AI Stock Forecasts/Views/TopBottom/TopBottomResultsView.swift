import SwiftUI

struct TopBottomResultsView: View {
    var sector: String
    var companyArray: [Company]
    var type: ArrowType

    var top5Array: Array<Company>.SubSequence {
        companyArray.sorted(by: {$0.totalScore > $1.totalScore}).prefix(5)
    }
    var bottom5Array: Array<Company>.SubSequence {
        companyArray.sorted(by: {$0.totalScore < $1.totalScore}).prefix(5)
    }
    var title: String {
        type == .up ? "Top 5" : "Bottom 5"
    }

    var body: some View {
        Form {
            Section(header: Text("\(title) companies")) {
                ForEach(type == .up ? top5Array : bottom5Array) { element in
                    NavigationLink(destination: ResultView(company: element)) {
                        HStack {
                            Text(element.name)
                            Spacer()
                            Text("score: \(Int(element.totalScore))")
                        }.padding()
                    }
                }
            }
        }
        .navigationTitle("\(sector.capitalized)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
