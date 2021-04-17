import SwiftUI

struct EditView: View {

    // MARK: - Properties

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentation

    let company: CustomCompany?

    @State private var showingAlert: Bool = false
    @State private var modificationMode: Bool
    @State private var name: String = ""
    @State private var id: String = ""
    @State private var arobase: String = ""
    @State private var sector: SectorEnum = .all

    // MARK: - Custom init

    init(company: CustomCompany?) {
        self.company = company
        _name = State(initialValue: company?.wrappedName ?? "Company Name")
        _id = State(initialValue: company?.wrappedId ?? "Stock Symbol")
        _arobase = State(initialValue: company?.wrappedArobase ?? "Twitter @")
        _sector = State(
            initialValue: SectorEnum.allCases.first(where: { $0.rawValue == company?.wrappedSector })
                ?? SectorEnum.all
        )
        _modificationMode = State(initialValue: company == nil)
    }

    // MARK: - body

    var body: some View {
        Form {
            // Text in display mode or Texfield in modification mode
            Section(header: Text("Name")) {
                modificationMode ?
                    AnyView(TextField(company?.wrappedName ?? "Company Name", text: $name))
                    : AnyView(Text(company?.wrappedName ?? "Company Name"))
            }
            // Text in display mode or Texfield in modification mode
            Section(header: Text("Stock Symbol")) {
                modificationMode ?
                    AnyView(TextField(company?.wrappedId ?? "Stock Symbol", text: $id))
                    : AnyView(Text(company?.wrappedId ?? "Stock Symbol"))
            }
            // Text in display mode or Texfield in modification mode
            Section(header: Text("Twitter @")) {
                modificationMode ?
                    AnyView(TextField(company?.wrappedArobase ?? "Twitter @", text: $arobase))
                    : AnyView(Text(company?.wrappedArobase ?? "Twitter @"))
            }
            // Text in display mode or Picker in modification mode
            Section(header: Text("Sector")) {
                modificationMode ?
                    AnyView(Picker(selection: $sector, label: Text(sector.rawValue.capitalized)) {
                        ForEach(SectorEnum.allCases, id: \.self) { sector in
                            Text(sector.rawValue.capitalized)
                        }
                    }.accessibilityLabel("\(sector.rawValue)"))
                    : AnyView(Text(company?.wrappedSector.capitalized ?? "all"))
            }
            Section(header: Text("Modify or Delete")) {
                // Modify Button in display mode or Cancel Button in modification mode
                modificationMode ?
                    Button("Cancel") {
                        modificationMode = false
                        presentation.wrappedValue.dismiss()
                    } :
                    Button("Modify") {
                        modificationMode = true
                    }
                // Delete Button in display mode or Save Button in modification mode
                modificationMode ?
                    Button("Save") {
                        saveCustomCompany()
                        modificationMode = false
                        presentation.wrappedValue.dismiss()
                    }.foregroundColor(.green) :
                    Button("Delete") {
                        showingAlert = true
                    }.foregroundColor(.red)
            }
        }
        .navigationTitle(company?.wrappedName ?? "New Company")
        .alert(isPresented: $showingAlert) { () -> Alert in
            Alert(
                title: Text("Delete Company"),
                message: Text("The deletion is permanent and cannot be undone. Are you sure?"),
                primaryButton: .cancel(Text("Cancel")),
                secondaryButton: .destructive(Text("Delete"), action: {
                    dataController.delete(company!)
                    dataController.save()
                    presentation.wrappedValue.dismiss()
                }))
        }
    }

    // MARK: - Helper functions

    func saveCustomCompany() {
        if let safeCompany = company {
            safeCompany.arobase = arobase
            safeCompany.id = id
            safeCompany.name = name
            safeCompany.sector = sector.rawValue
            dataController.save()
        } else {
            let newCompany = CustomCompany(context: dataController.container.viewContext)
            newCompany.id = id
            newCompany.name = name
            newCompany.arobase = arobase
            newCompany.sector = sector.rawValue
            dataController.save()
        }
    }
}
