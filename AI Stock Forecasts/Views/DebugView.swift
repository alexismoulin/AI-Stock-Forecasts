import SwiftUI

struct DebugView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        VStack {
            Text("DebugView for testing purposes only - do not ship in production")
            Button("Create Dummy") {
                dataController.createDummyData()
            }.padding()
            Button("Wipe all") {
                dataController.deleteAll()
            }.padding()
        }
    }
}
