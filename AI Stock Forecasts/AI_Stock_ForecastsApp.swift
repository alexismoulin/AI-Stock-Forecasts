import SwiftUI

@main
struct AI_Stock_ForecastsApp: App {
    let persistenceController = DataController.shared
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
