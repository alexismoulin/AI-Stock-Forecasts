import SwiftUI

struct EditView: View {
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentation
    
    let company: CustomCompany
    
    @State private var showingAlert: Bool = false
    @State private var modificationMode: Bool = false
    @State private var name: String
    @State private var id: String
    @State private var arobase: String
    @State private var sector: Sector
    
    init(company: CustomCompany) {
        self.company = company
        _name = State(initialValue: company.wrappedName)
        _id = State(initialValue: company.wrappedId)
        _arobase = State(initialValue: company.wrappedArobase)
        _sector = State(initialValue: Sector.allCases.first(where: {$0.rawValue == company.wrappedSector}) ?? Sector.all)
    }

    var body: some View {
        GeometryReader { geo in
            Form {
                // Text in display mode or Texfield in modification mode
                Section(header: Text("Name")) {
                    modificationMode ? AnyView(TextField(company.wrappedName, text: $name)) : AnyView(Text(company.wrappedName))
                }
                // Text in display mode or Texfield in modification mode
                Section(header: Text("Stock Symbol")) {
                    modificationMode ? AnyView(TextField(company.wrappedId, text: $id)) : AnyView(Text(company.wrappedId))
                }
                // Text in display mode or Texfield in modification mode
                Section(header: Text("Twitter @")) {
                    modificationMode ? AnyView(TextField(company.wrappedArobase, text: $arobase)) : AnyView(Text(company.wrappedArobase))
                }
                // Text in display mode or Picker in modification mode
                Section(header: Text("Sector")) {
                    modificationMode ?
                        AnyView(Picker(selection: $sector, label: Text(sector.rawValue.capitalized)) {
                            ForEach(Sector.allCases, id:\.self) { sector in
                                Text(sector.rawValue.capitalized)
                            }
                        }) :
                        AnyView(Text(company.wrappedSector.capitalized))
                }
                Section(header: Text("Modify or Delete")) {
                    // Modify Button in display mode or Cancel Button in modification mode
                    modificationMode ?
                        Button("Cancel") {
                            modificationMode = false
                        } :
                        Button("Modify") {
                            modificationMode = true
                        }
                    // Delete Button in display mode or Save Button in modification mode
                    modificationMode ?
                        Button("Save") {
                            company.arobase = arobase
                            company.id = id
                            company.name = name
                            company.sector = sector.rawValue
                            dataController.save()
                            modificationMode = false
                        }.foregroundColor(.green) :
                        Button("Delete") {
                            showingAlert = true
                        }.foregroundColor(.red)
                }
            }
        }
        .navigationTitle(company.wrappedName)
        .alert(isPresented: $showingAlert) { () -> Alert in
            Alert(
                title: Text("Delete Company"),
                message: Text("The deletion is permanent and cannot be undone. Are you sure?"),
                primaryButton: .cancel(Text("Cancel")),
                secondaryButton: .destructive(Text("Delete"), action: {
                    dataController.delete(company)
                    dataController.save()
                    presentation.wrappedValue.dismiss()
                }))
        }
    }
}
