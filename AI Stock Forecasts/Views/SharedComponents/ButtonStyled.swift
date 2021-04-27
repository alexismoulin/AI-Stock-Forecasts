import SwiftUI

struct ButtonStyled: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text.uppercased())
            .font(.system(.headline))
            .fontWeight(.bold)
            .foregroundColor(Color.white)
            .frame(width: 120, height: 50)
            .background(color)
            .cornerRadius(16.0)
    }
}
