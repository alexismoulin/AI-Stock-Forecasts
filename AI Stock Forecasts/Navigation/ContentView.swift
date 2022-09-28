import SwiftUI

struct ContentView: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @EnvironmentObject var model: Model
    var sector: String
    let fetchRequest: FetchRequest<CustomCompany>

    init(sector: String) {
        self.sector = sector
        fetchRequest = FetchRequest<CustomCompany>(
            entity: CustomCompany.entity(),
            sortDescriptors: [],
            predicate: sector == "all" ? nil : NSPredicate(format: "sector == %@", sector),
            animation: nil
        )
    }

    var body: some View {
        if sizeClass == .compact {
            TabNavigationView(sector: sector, fetchRequest: fetchRequest)
                .environmentObject(model)
        } else {
            SideBarNavigationView(sector: sector, fetchRequest: fetchRequest)
        }
    }
}
