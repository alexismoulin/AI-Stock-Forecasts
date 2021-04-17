import SwiftUI

struct SideBarNavigationView: View {
    @State private var selectedTab: Int = 0
    @SceneStorage("selectedView") var selectedView: String?
    var sector: String
    let fetchRequest: FetchRequest<CustomCompany>

    var body: some View {
        NavigationView {
            List(selection: $selectedView) {
                NavigationLink(destination: HomeView()) {
                    Label("Sector", systemImage: "globe")
                }.tag("0")
                NavigationLink(destination: SelectionView(sector: sector, fetchRequest: fetchRequest)) {
                    Label("Single", systemImage: "target")
                }.tag("1")
                NavigationLink(destination: TopBottomView(sector: sector, fetchRequest: fetchRequest)) {
                    Label("Top Bottom 5", systemImage: "arrow.up.arrow.down")
                }.tag("2")
                NavigationLink(destination: CustomCompanyList()) {
                    Label("Edit Companies", systemImage: "square.and.pencil")
                }.tag("3")
            }
            .navigationTitle("\(sector.capitalized)")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(SidebarListStyle())
            PlaceholderView()
        }
    }
}
