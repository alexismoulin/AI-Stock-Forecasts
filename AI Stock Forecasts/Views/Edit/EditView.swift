import SwiftUI

struct EditView: View {

    // MARK: - Properties

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentation

    let company: CustomCompany?

    @State private var showingAlert: Bool = false
    @State private var companyNameChecker = FieldChecker()
    @State private var stockSymbolChecker = FieldChecker()

    private var isValid: Bool {
        companyNameChecker.valid && stockSymbolChecker.valid
    }

    // MARK: - Custom init

    init(company: CustomCompany?) {
        self.company = company
        _name = State(initialValue: company?.wrappedName ?? "")
        _id = State(initialValue: company?.wrappedId ?? "")
        _arobase = State(initialValue: company?.wrappedArobase ?? "@")
        _sector = State(
            initialValue: SectorEnum.allCases.first(where: { $0.rawValue == company?.wrappedSector })
                ?? SectorEnum.all
        )
        _colorName = State(initialValue: company?.wrappedColorName ?? "Midnight")
    }

    // MARK: - Name section

    @State private var name: String = ""

    var nameSection: some View {
        Section(header: Text("Name")) {
            TextFieldWithValidator(
                title: "Company Name",
                value: $name,
                checker: $companyNameChecker
            ) { companyNameValue in
                if companyNameValue.isEmpty {
                    return "Company Name cannot be empty"
                }
                return nil
            }
            .autocapitalization(.none)
            .padding(companyNameChecker.padding)
            .overlay(ValidatorMessage(message: companyNameChecker.errorMessageOrNilAtBeginning), alignment: .bottom)
        }
    }

    // MARK: - Stock Symbol section

    @State private var id: String = ""

    var stockSymbolSection: some View {
        Section(header: Text("Stock Symbol")) {
            TextFieldWithValidator(
                title: "Stock Symbol",
                value: $id,
                checker: $stockSymbolChecker
            ) { stockSymbolValue in
                if stockSymbolValue.isEmpty {
                    return "Stock Symbol cannot be empty"
                } else if stockSymbolValue == "T?" {
                    return "Test"
                }
                return nil
            }
            .autocapitalization(.none)
            .padding(stockSymbolChecker.padding)
            .overlay(ValidatorMessage(message: stockSymbolChecker.errorMessageOrNilAtBeginning), alignment: .bottom)
        }
    }

    // MARK: - Twitter section

    @State private var arobase: String = ""

    var twitterSection: some View {
        Section(header: Text("Twitter @")) {
            TextField(company?.wrappedArobase ?? "Twitter @", text: $arobase)
        }
    }

    // MARK: - Sector section

    @State private var sector: SectorEnum = .all

    var sectorSection: some View {
        Section(header: Text("Sector")) {
            Picker(selection: $sector, label: Text(sector.rawValue.capitalized)) {
                ForEach(SectorEnum.allCases, id: \.self) { sector in
                    Text(sector.rawValue.capitalized)
                }
            }.accessibilityLabel("\(sector.rawValue)")
        }
    }

    // MARK: - Color section

    let colorColumns = [GridItem(.adaptive(minimum: 44))]
    @State private var colorName: String = "Midnight"

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == colorName {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            colorName = item
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(item == colorName ? [.isButton, .isSelected] : .isButton)
        .accessibilityLabel(LocalizedStringKey(item))
    }

    var colorSection: some View {
        Section(header: Text("Color")) {
            LazyVGrid(columns: colorColumns) {
                ForEach(CustomCompany.allColors, id: \.self, content: colorButton)
            }
            .padding(.vertical)
        }
    }

    // MARK: - action buttons section

    var actionButtonSection: some View {
        Section(header: Text("Actions")) {

            Button("Cancel") {
                presentation.wrappedValue.dismiss()
            }

            Button("Save") {
                saveCustomCompany()
                presentation.wrappedValue.dismiss()
            }
            .foregroundColor(isValid ? .green : .gray.opacity(0.5))
            .disabled(!isValid)

            Button("Delete") {
                showingAlert = true
            }
            .foregroundColor(.red)
        }
    }

    // MARK: - Main body

    var body: some View {
        Form {
            nameSection
            stockSymbolSection
            twitterSection
            sectorSection
            colorSection
            actionButtonSection
        }
        .navigationTitle(name)
        .alert("Delete Company", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                dataController.delete(company!)
                dataController.save()
                presentation.wrappedValue.dismiss()
            }
        } message: {
            Text("The deletion is permanent and cannot be undone. Are you sure?")
        }
    }

    // MARK: - Helper functions

    func saveCustomCompany() {
        if let safeCompany = company {
            safeCompany.arobase = arobase
            safeCompany.id = id
            safeCompany.name = name
            safeCompany.sector = sector.rawValue
            safeCompany.colorName = colorName
            safeCompany.objectWillChange.send()
            dataController.save()
        } else {
            let newCompany = CustomCompany(context: dataController.container.viewContext)
            newCompany.id = id
            newCompany.name = name
            newCompany.arobase = arobase
            newCompany.sector = sector.rawValue
            newCompany.colorName = colorName
            newCompany.objectWillChange.send()
            dataController.save()
        }
    }
}
