import SwiftUI

struct TextfieldIcon: View {

    var iconName: String
    @Binding var currentlyEditing: Bool
    @State private var colorAngle: Double = 0
    @Binding var passedImage: UIImage?

    var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .dark) {
                ZStack {
                    if currentlyEditing {
                        AngularGradient(
                            colors: CustomColorArray.gradient1,
                            center: .center,
                            angle: .degrees(colorAngle)
                        )
                        .blur(radius: 10)
                    }
                    Color("tertiaryBackground")
                        .cornerRadius(12)
                        .opacity(0.8)
                        .blur(radius: 3)
                        .onAppear {
                            withAnimation(.linear(duration: 7)) {
                                colorAngle += 350
                            }
                        }
                }
            }
        }
        .cornerRadius(12)
        .overlay(
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white, lineWidth: 1)
                    .blendMode(.overlay)
                if passedImage != nil {
                    Image(uiImage: passedImage!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 28, height: 28, alignment: .center)
                        .cornerRadius(8)
                } else {
                    Image(systemName: iconName)
                        .gradientForeground(colors: [Color("pink-gradient-1"), Color("pink-gradient-2")])
                        .font(.system(size: 17, weight: .medium))
                }
            }
        )
        .frame(width: 36, height: 36, alignment: .center)
        .padding([.vertical, .leading], 8)
    }
}

struct TextfieldIcon_Previews: PreviewProvider {
    static var previews: some View {
        TextfieldIcon(iconName: "key.fill", currentlyEditing: .constant(true), passedImage: .constant(nil))
    }
}
