import SwiftUI
import FirebaseAuth

struct TabNavigationView: View {

    @AppStorage("selectedTab") var selectedTab: Tab = .explore
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var model: Model
    @Environment(\.presentationMode) var presentationMode

    var sector: String
    let fetchRequest: FetchRequest<CustomCompany>

    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                switch selectedTab {
                case .explore:
                    SelectionView(sector: sector, fetchRequest: fetchRequest)
                case .topBottom:
                    TopBottomView(sector: sector, fetchRequest: fetchRequest)
                case .edit:
                    CustomCompanyList()
                case .sector:
                    SectorView()
                }
                TabBar()
                    .environmentObject(model)
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: setNavigationBar)
            .toolbar {
                SignOutButton(action: signout)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel())
            }
        }
    }

    // MARK: - Helper functions

    func setNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }

    func signout() {
        do {
            try Auth.auth().signOut()
            presentationMode.wrappedValue.dismiss()
        } catch {
            alertTitle = "Sign out failed"
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}
