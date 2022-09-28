import SwiftUI

struct BasicFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline.weight(.semibold))
            .foregroundColor(Color.primary.opacity(0.9))
    }
}

extension View {
    func basicFont() -> some View {
        modifier(BasicFontModifier())
    }
}
