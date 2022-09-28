import SwiftUI

struct TopBottomResultsView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
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

    var selectedArray: Array<Company>.SubSequence {
        type == .up ? top5Array : bottom5Array
    }

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea(.all)
            VStack {
                ForEach(selectedArray.indices) { index in
                    NavigationLink(destination: ResultView(company: selectedArray[index])) {
                        VStack {
                            if index != 0 { Divider() }
                            SectionRow(company: selectedArray[index])
                        }
                    }.buttonStyle(.plain)
                }
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .backgroundStyle(cornerRadius: 30)
            .padding(20)
            .padding(.vertical, 80)
            if sizeClass == .compact {
                TabBar()
            }
        }
        .navigationTitle("\(title + " - " + sector.capitalized)")
        .navigationBarTitleDisplayMode(.inline)
        .background(BackgroundBlob(style: .topBottom))
    }
}

struct TopBottomResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TopBottomResultsView(
            sector: "industrials",
            companyArray: [
                Company.example,
                Company.example,
                Company.example,
                Company.example,
                Company.example
            ],
            type: .up
        )
            .preferredColorScheme(.dark)
    }
}
