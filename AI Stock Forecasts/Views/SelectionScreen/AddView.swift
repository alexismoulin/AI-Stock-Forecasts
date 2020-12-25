import SwiftUI

struct AddView: View {
    let sector: String
    @State private var symbol: String = ""
    @State private var name: String = ""
    @State private var arobase: String = ""
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    var notReady: Bool {
        symbol.isEmpty || name.isEmpty || arobase.first != "@"
    }
    
    var body: some View {
        ZStack {
            Form {
                Section(header: Text("Add a custom company")) {
                    TextField("Stock Symbol", text: $symbol)
                    TextField("Company Name", text: $name)
                    TextField("Twitter @", text: $arobase)
                }
            }
            VStack {
                Spacer()
                Button {
                    let newCustomCompany = CustomCompany(context: moc)
                    newCustomCompany.id = symbol
                    newCustomCompany.name = name
                    newCustomCompany.arobase = arobase
                    newCustomCompany.sector = sector
                    dataController.save()
                    presentation.wrappedValue.dismiss()
                } label: {
                    notReady ? ButtonStyled(text: "Not Ready", color: Color.gray.opacity(0.5)) : ButtonStyled(text: "Add", color: .blue)
                }
                .disabled(notReady)
                .padding(.bottom, 20)
            }
        }
    }
}

