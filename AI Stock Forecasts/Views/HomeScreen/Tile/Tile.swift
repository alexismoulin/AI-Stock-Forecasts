import SwiftUI

struct Tile: View {
    let sector: String
    var body: some View {
        NavigationLink(destination: SectorTabView(sector: sector)) {
            VStack {
                Image(sector)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 128, height: 128)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 2))
                Divider()
                Text(sector.uppercased())
            }
        }
    }
}

struct Tile2: View {
    let sector: String
    var size: CGFloat
    var body: some View {
        VStack {
            Image(sector)
                .renderingMode(.original)
                .resizable()
                .frame(width: size, height: size)
                .padding(5)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            Divider()
            Text(sector.uppercased()).font(.caption)
        }
    }
}
