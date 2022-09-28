import SwiftUI

struct GradientButton: View {

    var buttonImage: String?
    var buttonTitle: String
    var buttonAction: () -> Void
    @State private var angle: Double = 0

    var body: some View {
        Button(action: buttonAction) {
            GeometryReader { geo in
                ZStack {
                    AngularGradient(colors: CustomColorArray.gradient1, center: .center, angle: .degrees(angle))
                        .blendMode(.overlay)
                        .blur(radius: 8)
                        .mask(
                            RoundedRectangle(cornerRadius: 16)
                                .frame(height: 50)
                                .frame(maxWidth: geo.size.width - 16)
                                .blur(radius: 8)
                        )
                        .onAppear {
                            withAnimation(.linear(duration: 7)) {
                                angle += 350
                            }
                        }
                    HStack(spacing: 20) {
                        if buttonImage != nil {
                            GradientIcon(text: buttonImage!)
                                .font(.title)
                        }
                        GradientText(text: buttonTitle)
                    }
                    .font(.headline)
                    .frame(width: geo.size.width - 16, height: 50)
                    .background(Color("tertiaryBackground").opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 2)
                            .blendMode(.normal)
                            .opacity(0.7)
                    )
                    .cornerRadius(16)
                }
            }
            .frame(height: 50)
        }
    }
}

struct GradientButton2: View {

    var buttonImage: String
    var buttonTitle: String
    var buttonAction: () -> Void
    @State private var angle: Double = 0

    var body: some View {
        Button(action: buttonAction) {
                ZStack {
                    AngularGradient(colors: CustomColorArray.gradient1, center: .center, angle: .degrees(angle))
                        .blendMode(.overlay)
                        .blur(radius: 8)
                        .mask(
                            RoundedRectangle(cornerRadius: 32)
                                .frame(height: 150)
                                .frame(maxWidth: 150)
                                .blur(radius: 8)
                        )
                        .onAppear {
                            withAnimation(.linear(duration: 7)) {
                                angle += 350
                            }
                        }
                    VStack(spacing: 15) {
                        GradientIcon(text: buttonImage)
                            .font(.system(size: 60))
                        GradientText(text: buttonTitle)
                            .font(.system(size: 15))
                    }
                    .font(.headline)
                    .frame(width: 150, height: 150)
                    .background(Color("tertiaryBackground").opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(.white, lineWidth: 2)
                            .blendMode(.normal)
                            .opacity(0.7)
                    )
                    .cornerRadius(32)
                }
            .frame(height: 100)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GradientButton2(buttonImage: "faceid", buttonTitle: "Login with FaceID", buttonAction: {})
            .padding()
    }
}
