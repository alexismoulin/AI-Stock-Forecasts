import SwiftUI

struct CardStyleModifier: ViewModifier {
    var height: CGFloat
    func body(content: Content) -> some View {
        content
            .padding(.all, 20.0)
            .padding(.vertical, 20.0)
            .frame(height: height)
            .background(.ultraThinMaterial)
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .strokeStyle(cornerRadius: 30)
            .padding(.horizontal, 20)
            .shadow(color: Color("Shadow").opacity(0.3), radius: 10, x: 0, y: 10)
    }
}

extension View {
    func cardStyle(height: CGFloat) -> some View {
        self.modifier(CardStyleModifier(height: height))
    }
}
