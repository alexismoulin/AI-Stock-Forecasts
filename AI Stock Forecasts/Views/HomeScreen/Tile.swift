import SwiftUI
import VisualEffects

struct Tile: View {
    let sector: String
    let selected: Bool
    var body: some View {
        VStack {
            Image(sector)
                .resizable()
                .frame(width: selected ? 128 : 120, height: selected ? 128 : 120)
                .padding()
                .background(selected ? BackgroundEffect(color1: .gray, color2: .blue) : nil)
                .clipShape(RoundedRectangle(cornerRadius: selected ? 25 : 20))
                .overlay(
                    RoundedRectangle(cornerRadius: selected ? 25 : 20)
                        .stroke(selected ? Color.blue : Color.gray, lineWidth: selected ? 3 : 2)
                )
                .padding(.top)
            Divider()
            Text(sector.uppercased())
                .fontWeight(selected ? .heavy: .none)
                .foregroundColor(selected ? .blue : .gray)
        }
    }
}
