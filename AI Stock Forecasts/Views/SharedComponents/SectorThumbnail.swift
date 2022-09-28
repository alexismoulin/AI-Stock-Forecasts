import SwiftUI

struct SectorThumbnail: View {
    let sector: String

    var body: some View {
        Image(sector)
            .resizable()
            .frame(width: 26, height: 26)
            .cornerRadius(10)
            .padding(8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .strokeStyle(cornerRadius: 18)
    }
}
