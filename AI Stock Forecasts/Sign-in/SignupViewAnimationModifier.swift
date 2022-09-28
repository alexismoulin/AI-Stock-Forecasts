import SwiftUI

struct SignupViewAnimationModifier: ViewModifier {
    var rotationAngle: Double

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(Angle(degrees: rotationAngle), axis: (x: 0, y: 1, z: 0))
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(.thinMaterial)
                    .colorScheme(.dark)
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            )
            .cornerRadius(30)
            .padding(.horizontal)
            .rotation3DEffect(Angle(degrees: rotationAngle), axis: (x: 0, y: 1, z: 0))
    }
}

extension View {
    func signupViewAnimationModifier(rotationAngle: Double) -> some View {
        self.modifier(SignupViewAnimationModifier(rotationAngle: rotationAngle))
    }
}
