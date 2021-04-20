import SwiftUI

struct Overview: View {
    let company: Company
    let formattedDate: String
    init(company: Company) {
        self.company = company
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        formattedDate = format.string(from: date)
    }

    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: company.hash) ?? UIImage(named: "custom")!)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 100, maxHeight: 100)
                .padding(5)
                .background(Color.background)
                .cornerRadius(5)
                .padding(5)
            VStack(alignment: .leading) {
                Text("\(company.name)")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Symbol: \(company.id)")
                    .font(.subheadline)
            }.padding(5)
        }.frame(maxWidth: .infinity, maxHeight: 120).background(Color(UIColor.lightGray))
        .cornerRadius(10)
        .padding(.horizontal, 5)
        .shadow(radius: 3)
    }
}

struct Overview_Previews: PreviewProvider {
    static let apple = Company(id: "AAPL", name: "Apple Inc", arobase: "@apple", sector: "technology", custom: false)
    static var previews: some View {
        Overview(company: apple)
    }
}
