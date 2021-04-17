import SwiftUI

struct TabNavigationView: View {

    @State private var selectedTab: Int = 0
    var sector: String
    let fetchRequest: FetchRequest<CustomCompany>

    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: EditView(company: nil)) {
                Label("Add Company", systemImage: "plus")
            }
        }
    }

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                    .tabItem {
                        Image(systemName: "globe")
                        Text("Sector")
                    }
                SelectionView(sector: sector, fetchRequest: fetchRequest)
                    .tag(1)
                    .tabItem {
                        Image(systemName: "target")
                        Text("Search")
                    }
                TopBottomView(sector: sector, fetchRequest: fetchRequest)
                    .tag(2)
                    .tabItem {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Top Bottom 5")
                    }
                CustomCompanyList()
                    .tag(3)
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                        Text("Edit Companies")
                    }
            }
            .colorScheme(.light)
            .navigationTitle(selectedTab == 3 ? "Your custom companies" : "\(sector.capitalized)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                addProjectToolbarItem
            }
        }
    }
}
