import SwiftUI

struct SectionTitle: View {
    var title: String
    var subTitle: String?
    var body: some View {
        return VStack {
            Text(title)
                .font(.system(.title))
                .fontWeight(.heavy)
                .padding(.top, 5)
            if let subTitle = subTitle {
                Text(subTitle)
                    .font(.system(.subheadline))
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray.opacity(0.9))
            }
        }
    }
}
