import SwiftUI

struct GradientIcon: View {

    var text: String

    var body: some View {
        Image(systemName: text)
            .gradientForeground(colors: [Color("pink-gradient-1"), Color("pink-gradient-2")])
    }
}

extension View {
    func gradientIconForeground(colors: [Color]) -> some View {
        self
            .overlay(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(self)
    }
}
