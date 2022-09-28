import SwiftUI

struct SelectionView: View {

    // MARK: - Properties

    @EnvironmentObject var network: Networking
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var sector: String
    var fetchRequest: FetchRequest<CustomCompany>
    var allCompanies: [Company]
    var selectedCompany: Company {
        allCompanies.first(where: { $0.id == selectedCompanyId }) ?? allCompanies[0]
    }

    @State private var selectedCompanyId: String = ""
    @State private var presentPicker: Bool = false
    @State private var fieldString: String = ""
    @State private var tag: Int = 1
    @State private var searchType: SearchType = .all
    @State private var status: Status = .forecast
    @State private var progression: Double = 0

    // MARK: - Custom init

    init(sector: String, fetchRequest: FetchRequest<CustomCompany>) {
        self.sector = sector
        self.fetchRequest = fetchRequest
        // fetch standard companies
        guard let baseCompanies: [BaseCompany] = BaseCompany.loadSectorData(for: sector) else {
            fatalError("Not able to load base companies")
        }
        let firstCompanies: [Company] = baseCompanies.loadBaseCompanies()
        // fetch custom companies
        let secondCompanies: [Company] = fetchRequest.wrappedValue.loadCustomCompanies()
        // sort all companies
        allCompanies = firstCompanies + secondCompanies
        allCompanies.sort {
            $0.name < $1.name
        }
    }

    var companies: [Company] {
        switch searchType {
        case .standard:
            return allCompanies.filter { $0.custom == false }
        case .custo:
            return allCompanies.filter { $0.custom == true }
        case .all:
            return allCompanies
        }
    }

    // MARK: - Screen body

    var body: some View {
        ZStack {
            if verticalSizeClass == .compact {
                ScrollView {
                    content
                }
            } else {
                content
            }
            if presentPicker {
                customPickerList
            }
        }
        .onAppear(perform: initializeView)
        .navigationTitle("Select a company")
        .background(BackgroundBlob(style: .explore))
        .alert(isPresented: $network.noInternet, content: displayAlert)
    }

    // MARK: - Components

    private var content: some View {
        VStack(alignment: .center) {
            typeSegmentedPicker
            Divider()
            customPickerTextField
            if !fieldString.isEmpty {
                Overview(company: selectedCompany)
            }
            Spacer()
            createButtons(buttonStatus: status)
                .padding(.top, 5)
            ProgressView(value: progression, total: 1)
                .tint(.teal)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
            Color.clear.frame(height: 50)
        }
    }

    private var typeSegmentedPicker: some View {
        VStack(alignment: .leading) {
            Text("COMPANY TYPE")
                .basicFont()
            Picker(selection: $searchType, label: Text(searchType.rawValue.capitalized)) {
                ForEach(SearchType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized)
                }
            }
            .onChange(of: searchType) { _ in
                fieldString = ""
            }
            .pickerStyle(SegmentedPickerStyle())
        }.padding()
    }

    private var customPickerTextField: some View {
        VStack(alignment: .leading) {
            Text("COMPANY SELECTION")
                .basicFont()
            CustomPickerTextView(
                presentPicker: $presentPicker,
                fieldString: $fieldString,
                placeholder: "Select a company"
            ).disabled(status != .forecast)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }.padding()
    }

    private var customPickerList: some View {
        CustomPickerView(
            items: companies,
            pickerField: $fieldString,
            presentPicker: $presentPicker,
            selectedCompanyId: $selectedCompanyId
        )
            .zIndex(1.0)
    }

    private func displayAlert() -> Alert {
        Alert(
            title: Text("No Network"),
            message: Text("Please make sure you have network and try again"),
            dismissButton: .default(Text("OK")) {
                status = .forecast
                progression = 0
            }
        )
    }

    @ViewBuilder
    private func createButtons(buttonStatus: Status) -> some View {
        switch buttonStatus {
        case .forecast:
            Button {
                status = .analyzing
                callNetwork()
            } label: {
                AngularButton(title: "Forecast", icon: "location.fill")
                    .padding(.horizontal, 30)
            }
        case .analyzing:
            Button { } label: {
                AngularButton(title: "Analyzing", icon: "hourglass")
                    .padding(.horizontal, 30)
            }.disabled(true)
        case .results:
            NavigationLink(destination: ResultView(company: selectedCompany)) {
                AngularButton(title: "Results", icon: "chart.bar.xaxis")
                    .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Helper functions

    private func callNetwork() {
        network.fetchTweets(company: selectedCompany, using: .arobase) { tags1 in
            progression = 0.33
            network.fetchTweets(company: selectedCompany, using: .hash) { tags2 in
                progression = 0.66
                network.fetchData(company: selectedCompany) { tags3 in
                    selectedCompany.tags = tags1 + tags2 + tags3
                    progression = 1
                    status = .results
                }
            }
        }
    }

    private func initializeView() {
        fieldString = selectedCompany.name
        searchType = .all
        presentPicker = false
        status = .forecast
        progression = 0
    }
}
