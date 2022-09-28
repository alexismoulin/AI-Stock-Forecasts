import SwiftUI

struct SideBarNavigationView: View {
    @EnvironmentObject var dataController: DataController
    @State private var selectedTab: Int = 0
    @SceneStorage("selectedView") var selectedView: String?
    var sector: String
    let fetchRequest: FetchRequest<CustomCompany>

    @ViewBuilder
    func titleBar() -> some View {
        if selectedTab != 2 {
        HStack {
            Text(sector.capitalized)
                .font(.headline)
                .bold()
            SectorThumbnail(sector: sector)
        }
        } else {
            Text("Your custom companies")
                .font(.headline)
                .bold()
        }
    }

    var body: some View {
        NavigationView {
            List(selection: $selectedView) {
                NavigationLink(destination: SelectionView(sector: sector, fetchRequest: fetchRequest)) {
                    Label("Search", systemImage: "magnifyingglass")
                }.tag(0)
                NavigationLink(destination: TopBottomView(sector: sector, fetchRequest: fetchRequest)) {
                    Label("Top Bottom 5", systemImage: "arrow.up.arrow.down")
                }.tag(1)
                NavigationLink(destination: CustomCompanyList()) {
                    Label("Edit Companies", systemImage: "square.and.pencil")
                }.tag(2)
                NavigationLink(destination: SectorView()) {
                    Label("Sector", systemImage: "globe")
                }.tag(3)
            }
            .toolbar {
                ToolbarItem(placement: .principal, content: titleBar)
            }
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(SidebarListStyle())

            PlaceholderView()
        }
    }
}
