import SwiftUI

struct DetailView: View {
    let company: Company

    // MARK: - Components

    var buyTagsSection: some View {
        Section {
            ForEach(company.tags.buyTags, id: \.self) { tuple in
                Text(tuple.text).badge(tuple.source.rawValue)
            }
        } header: {
            Text("Buy Tags")
        }
    }

    var holdTagsSection: some View {
        Section {
            ForEach(company.tags.holdTags, id: \.self) { tuple in
                Text(tuple.text).badge(tuple.source.rawValue)
            }
        } header: {
            Text("Hold Tags")
        }
    }

    var sellTagsSection: some View {
        Section {
            ForEach(company.tags.sellTags, id: \.self) { tuple in
                Text(tuple.text).badge(tuple.source.rawValue)
            }
        } header: {
            Text("Sell Tags")
        }
    }

    var body: some View {
        NavigationView {
            List {
                buyTagsSection
                holdTagsSection
                sellTagsSection
            }
            .navigationTitle("Details for \(company.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(company: Company.example)
    }
}
