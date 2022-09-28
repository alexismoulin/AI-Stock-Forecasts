import SwiftUI

struct SectorView: View {

    let layout = [GridItem(.flexible()), GridItem(.flexible())]
    let layout2 = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @AppStorage("sector") var sector: String = SectorEnum.all.rawValue
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: sizeClass == .compact ? layout : layout2, spacing: 10) {
                    ForEach(SectorEnum.allCases, id: \.self) { sect in
                        Tile(sector: sect.rawValue, selected: sect.rawValue == sector)
                            .onTapGesture {
                                sector = sect.rawValue
                            }
                    }
                }.padding(.bottom, 60)
            }
        }
        .navigationTitle("Filter by sector")
        .background(BackgroundBlob(style: .sector))
    }
}
