import SwiftUI

struct BackgroundEffect: View {
    let color1: Color
    let color2: Color
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [color1, color2]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).background(.ultraThinMaterial)
        }
    }
}
