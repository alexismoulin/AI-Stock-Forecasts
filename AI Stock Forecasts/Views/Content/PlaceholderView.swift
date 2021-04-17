import SwiftUI
import VisualEffects

struct PlaceholderView: View {
    var body: some View {
        ZStack(alignment: .top) {
            BackgroundEffect(color1: .launchScreenPurple, color2: .clear).edgesIgnoringSafeArea(.vertical)
            VStack {
                HStack(spacing: 10) {
                    Image("titleImage")
                        .resizable()
                        .frame(width: 64, height: 64)
                    Text("AI Stock Forecasts")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }.padding()

                Text("Please select an action in the left side bar")
                    .italic()
                    .foregroundColor(Color.white.opacity(0.9))
            }
        }
    }
}
