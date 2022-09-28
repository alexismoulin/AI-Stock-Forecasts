import SwiftUI

struct GradientText: View {

    var text: String

    var body: some View {
        Text(text)
            .gradientForeground(colors: [Color("pink-gradient-1"), Color("pink-gradient-2")])
    }
}

extension View {
    func gradientForeground(colors: [Color]) -> some View {
        self
            .overlay(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(self)
    }
}
