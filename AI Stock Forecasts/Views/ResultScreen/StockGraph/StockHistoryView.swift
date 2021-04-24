import SwiftUI

struct StockHistoryView: View {

    let data: [StockLog]
    @State var selectedIndex: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            StockHistoryText(
                logs: data,
                curr: Date(timeIntervalSince1970: 1609282718),
                selectedIndex: $selectedIndex
            )
            StockGraph(
                logs: data,
                curr: Date(timeIntervalSince1970: 1609282718),
                selectedIndex: $selectedIndex,
                color: .blue
            )

        }.padding()
    }
}
