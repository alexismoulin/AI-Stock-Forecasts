import SwiftUI

struct CircleCard: View {

    let company: Company
    let height: CGFloat

    var selectedSegment: Segment {
        switch company.totalScore {
        case -100..<(-60):
            return Segment(color: Color.red.opacity(0.8), amount: 0, title: "Strong Sell")
        case -60..<(-20):
            return Segment(color: Color.orange.opacity(0.8), amount: 40, title: "Sell")
        case -20..<20:
            return Segment(color: Color.yellow.opacity(0.8), amount: 80, title: "Hold")
        case 20..<60:
            return Segment(color: Color.green.opacity(0.8), amount: 120, title: "Buy")
        case 60...100:
            return Segment(color: Color.blue.opacity(0.8), amount: 160, title: "Strong Buy")
        default:
            return Segment(color: Color.gray.opacity(0.8), amount: 0, title: "Error")
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            ratingTitle
            circularControl
            summary
                .frame(maxWidth: 800)
                .padding(.top, 16)
            ratingSubtitle
                .padding(5)
        }
        .cardStyle(height: height)
    }

    // MARK: - Components

    private var ratingTitle: some View {
        Text(selectedSegment.title)
            .font(.system(size: 60, weight: .bold, design: .rounded))
            .foregroundColor(selectedSegment.color)
            .animation(nil)
            .frame(height: 60)
    }

    private var circularControl: some View {
            VStack {
                Text("\(Int(company.totalScore))")
                    .font(Font.system(size: height * 0.2, weight: .bold, design: .rounded))
                Text("Ratings")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .opacity(0.9)
            }
            .frame(width: height * 0.4, height: height * 0.4, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
            .mask(Circle())
            .padding(12)
            .background(Color(UIColor.systemBackground).opacity(0.3))
            .mask(Circle())
            .overlay(CircularView(value: company.calculatedScore, lineWidth: 22))
            .padding(.vertical, 20)
    }

    private var summary: some View {
        HStack {
            summaryElement(color: .green, text: "\(company.tags.buyTags.count) Buy")
            Spacer()
            summaryElement(color: .gray, text: "\(company.tags.holdTags.count) Hold")
            Spacer()
            summaryElement(color: .red, text: "\(company.tags.sellTags.count) Sell")
        }
    }

    func summaryElement(color: Color, text: String) -> some View {
        return HStack(alignment: .center, spacing: 10) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(color.opacity(0.8))
            Text(text)
                .fontWeight(.semibold)
                .foregroundColor(color.opacity(0.8))
        }

    }

    var ratingSubtitle: some View {
        Group {
            Text("Based on the latest ")
                .font(.subheadline)
                .foregroundColor(Color.secondary.opacity(0.9))
            + Text("\(company.allTags)")
                .bold()
            + Text(" sentiment analysis giving ratings to ")
                .font(.subheadline)
                .foregroundColor(Color.secondary.opacity(0.9))
            + Text("\(company.name)")
                .bold()
        }.fixedSize(horizontal: false, vertical: true)
    }
}

struct CircleCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleCard(company: Company.example, height: 600)
                .previewDevice("iPhone 13 Pro")
            CircleCard(company: Company.example, height: 600)
                .previewDevice("iPhone SE (2nd generation)")
            CircleCard(company: Company.example, height: 600)
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
.previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
