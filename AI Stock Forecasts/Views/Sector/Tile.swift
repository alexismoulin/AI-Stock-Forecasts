import SwiftUI

struct Tile: View {
    let sector: String
    let selected: Bool
    let animationDuration: Double = 0.25
    var body: some View {
        VStack {
            Image(sector)
                .resizable()
                .frame(width: selected ? 128 : 120, height: selected ? 128 : 120)
                .padding()
                .background(selected ? BackgroundEffect(color1: .gray, color2: .blue) : nil)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: selected ? 25 : 20))
                .overlay(
                    RoundedRectangle(cornerRadius: selected ? 25 : 20)
                        .stroke(selected ? Color.blue : Color.gray, lineWidth: selected ? 3 : 2)
                )
                .padding(.top)
                .animation(.linear(duration: animationDuration), value: selected)
            Divider()
            Text(sector.uppercased())
                .animatableFont(
                    size: selected ? 17 : 16,
                    weight: selected ? .heavy : .regular,
                    design: selected ? .default : .rounded
                )
                .foregroundColor(selected ? .blue : .primary)
                .animation(.linear(duration: animationDuration), value: selected)
        }
    }
}
