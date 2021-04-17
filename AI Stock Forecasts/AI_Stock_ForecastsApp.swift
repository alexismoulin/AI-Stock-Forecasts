import SwiftUI

@main
// swiftlint:disable:next type_name
struct AI_Stock_ForecastsApp: App {
    @StateObject var dataController: DataController
    @AppStorage("sector") var sector: String = SectorEnum.industrials.rawValue

    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(sector: sector)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
