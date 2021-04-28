import SwiftUI

struct SelectionView: View {

    // MARK: - Properties

    let network = Networking()
    var sector: String
    var fetchRequest: FetchRequest<CustomCompany>
    var allCompanies: [Company]
    var selectedCompany: Company {
        allCompanies.first(where: { $0.id == selectedCompanyId }) ?? allCompanies[0]
    }

    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var selectedCompanyId: String = ""
    @State private var ready: Bool = false
    @State private var progression: Double = 0.0
    @State private var presentPicker: Bool = false
    @State private var fieldString: String = ""
    @State private var tag: Int = 1

    // MARK: - Custom init

    init(sector: String, fetchRequest: FetchRequest<CustomCompany>) {
        self.sector = sector
        self.fetchRequest = fetchRequest
        allCompanies = CompaniesModel.getAllCompaniesFromSector(for: sector)
            ?? [Company(id: "ERROR", name: "ERROR", arobase: "ERROR", sector: "ERROR", custom: false)]
        for custom in fetchRequest.wrappedValue {
            allCompanies.append(Company(
                id: custom.wrappedId,
                name: custom.wrappedName,
                arobase: custom.wrappedArobase,
                sector: custom.wrappedSector,
                custom: true
            ))
        }
        allCompanies.sort {
            $0.name < $1.name
        }
    }

    // MARK: - Screen body

    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.vertical)
            VStack(alignment: .center, spacing: 5) {
                SectionTitle(title: "Company Selection")
                CustomPickerTextView(
                    presentPicker: $presentPicker,
                    fieldString: $fieldString,
                    placeholder: "Select a company"
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                Overview(company: selectedCompany)
                Spacer()
                createButtons().padding(.top, 5)
                ProgressView(value: progression, total: 1.0).padding(5)
            }
            if presentPicker {
                CustomPickerView(
                    items: allCompanies,
                    pickerField: $fieldString,
                    presentPicker: $presentPicker,
                    selectedCompanyId: $selectedCompanyId
                ).zIndex(1.0)
            }
        }
        .navigationTitle("\(sector.capitalized)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            addCompanyToolbarItem
        }
        .onAppear {
            ready = false
            progression = 0
        }
    }

    // MARK: - Components

    private func createLogoImage(companyId: String) -> some View {
        return Image(uiImage: UIImage(named: "#\(companyId)") ?? UIImage(named: "custom")!)
            .resizable()
            .scaledToFit()
            .padding(5)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            .shadow(color: .gray, radius: 2)
            .padding()
    }

    private func createButtons() -> some View {
        if !ready {
            return AnyView(Button {
                network.fetchTweets1(company: selectedCompany.arobase) { arobaseScore in
                    progression = 0.3
                    network.fetchTweets2(company: selectedCompany.hash) { hashScore in
                        progression = 0.6
                        network.fetchData(company: String(selectedCompany.arobase.dropFirst())) { newsScore in
                            selectedCompany.arobaseScore = arobaseScore
                            selectedCompany.hashScore = hashScore
                            selectedCompany.newsScore = newsScore
                            progression = 1.0
                            ready = true
                        }
                    }
                }
            } label: {
                ButtonStyled(text: "forecast", color: .buttonColor)
            })
        } else {
            return AnyView(NavigationLink(destination: ResultView(company: selectedCompany)) {
                ButtonStyled(text: "results", color: .blue)
            })
        }

    }
}
