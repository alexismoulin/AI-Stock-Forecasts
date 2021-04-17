import SwiftUI

struct HomeView: View {

    let layout = [GridItem(.flexible()), GridItem(.flexible())]
    let layout2 = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @AppStorage("sector") var sector: String = SectorEnum.industrials.rawValue
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.vertical)
            ScrollView {
                LazyVGrid(columns: sizeClass == .compact ? layout : layout2, spacing: 10) {
                    ForEach(SectorEnum.allCases, id: \.self) { sect in
                        Tile(sector: sect.rawValue, selected: sect.rawValue == sector)
                            .onTapGesture {
                                withAnimation {
                                    sector = sect.rawValue
                                }
                            }
                    }
                }
            }
        }.navigationTitle("Select a sector")
    }
}
