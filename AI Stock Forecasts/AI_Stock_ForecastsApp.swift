import SwiftUI
import Firebase

@main
// swiftlint:disable:next type_name
struct AI_Stock_ForecastsApp: App {
    @StateObject var dataController: DataController
    @StateObject var network: Networking
    @StateObject var model = Model()
    @StateObject var authenticationManager = AuthenticationManager()
    @StateObject var signupViewModel = SignupViewModel()
    @AppStorage("sector") var sector: String = SectorEnum.all.rawValue
    @Environment(\.scenePhase) private var scenePhase

    init() {
        FirebaseApp.configure()
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
        dataController.debugMode = false
        if dataController.debugMode {
            dataController.deleteAll()
            dataController.createDummyData()
        }
        let network = Networking()
        _network = StateObject(wrappedValue: network)
    }

    var body: some Scene {
        WindowGroup {
            SignupView(sector: sector)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(network)
                .environmentObject(model)
                .environmentObject(authenticationManager)
                .environmentObject(signupViewModel)
        }
    }
}
