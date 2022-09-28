import SwiftUI

struct SignOutButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.turn.up.forward.iphone.fill")
                .foregroundColor(.primary.opacity(0.75))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 0, z: 1))
        }
    }
}
