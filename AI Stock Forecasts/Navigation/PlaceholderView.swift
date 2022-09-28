import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        ZStack(alignment: .top) {
            BackgroundEffect(color1: .launchScreenPurple, color2: .clear).edgesIgnoringSafeArea(.vertical)
            VStack {
                HStack(spacing: 10) {
                    Image("titleImage")
                        .resizable()
                        .frame(width: 121, height: 120)
                    Text("AI Stock Forecasts")
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                }.padding()

                Text("Please select an action in the left side bar")
                    .italic()
                    .font(.title)
                    .foregroundColor(Color.white.opacity(0.9))
            }
        }
    }
}
