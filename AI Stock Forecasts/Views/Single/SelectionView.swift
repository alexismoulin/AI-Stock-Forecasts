import SwiftUI

struct SelectionView: View {

    let network = Networking()

    // MARK: - Variables

    var sector: String
    var fetchRequest: FetchRequest<CustomCompany>
    var allCompanies: [Company]

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

    // MARK: - States

    @State private var selectedCompanyId: String = ""
    @State private var ready: Bool = false
    @State private var progression: Double = 0.0
    @State private var presentPicker: Bool = false
    @State private var fieldString: String = ""
    @State private var tag: Int = 1

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
                Spacer()
                Divider()
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
        // ButtonStyled is a custom component which can be found in the Components folder
        let predictButton = ButtonStyled(text: "forecast", color: Color.black)
        let buttonBeforePredict = ButtonStyled(text: "not ready", color: Color.gray.opacity(0.5))
        let buttonAfterPredict = ButtonStyled(text: "results", color: Color.blue)
        let selectedCompany: Company = allCompanies.first(where: { $0.id == selectedCompanyId }) ?? allCompanies[0]

        return HStack(spacing: 16.0) {
            Button {
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
                predictButton
            }
            NavigationLink(destination: ResultView(company: selectedCompany)) {
                ready ? buttonAfterPredict : buttonBeforePredict
            }
            .disabled(!ready)
            .simultaneousGesture(TapGesture().onEnded({
                ready = false
                progression = 0.0
            }))
        }
    }
}
