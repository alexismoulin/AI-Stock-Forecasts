import SwiftUI

struct TopBottomView: View {

    // MARK: - Properties

    @EnvironmentObject var network: Networking
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var sector: String
    var fetchRequest: FetchRequest<CustomCompany>
    var allCompanies: [Company]

    @State private var arrowType: ArrowType = .up
    @State private var status: Status = .forecast
    @State private var progression: Double = 0
    @State private var callNumber: Int = 0

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
    }

    // MARK: - body

    var body: some View {
        ZStack {
            if verticalSizeClass == .compact {
                ScrollView {
                    content
                }
            } else {
                content
            }
        }
        .onAppear(perform: initializeView)
        .navigationTitle(arrowType == .up ? "Top 5 companies" : "Bottom 5 companies")
        .background(BackgroundBlob(style: .topBottom))
        .alert(isPresented: $network.noInternet, content: displayAlert)
    }

    // MARK: - Scrollable content

    var content: some View {
        VStack {
            topSection.padding(.bottom)
            Divider()
            Spacer()
            ArrowComponent(arrowType: $arrowType)
                .padding(.vertical, -40)
            Spacer()
            bottomSection
            Color.clear.frame(height: 50)
        }
    }

    // MARK: - Top section components

    private var titleText: some View {
        Text(
            arrowType == .up ?
            "Best 5 stocks in the sector".uppercased()
            : "Worst 5 stocks in the sector".uppercased()
        )
            .basicFont()
            .padding([.top, .leading])
    }

    private var segmentedPicker: some View {
        Picker(selection: $arrowType.animation(.easeIn(duration: 0.5)), label: Text("Arrow label")) {
            ForEach(ArrowType.allCases, id: \.self) {
                Text($0 == .up ? "Top 5" : "Bottom 5")
                    .font(.largeTitle)
            }
        }
        .padding(.horizontal)
        .pickerStyle(SegmentedPickerStyle())
        .disabled(status != .forecast)
    }

    private var topSection: some View {
        VStack(alignment: .leading) {
            titleText
            segmentedPicker
        }
    }

    // MARK: - Bottom section components

    @ViewBuilder
    private func createButtons(buttonStatus: Status) -> some View {
        switch buttonStatus {
        case .forecast:
            Button {
                status = .analyzing
                multipleCallNetwork(numberOfCompanies: Double(allCompanies.count))
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
            NavigationLink(destination: TopBottomResultsView(
                sector: sector,
                companyArray: allCompanies,
                type: arrowType
            )) {
                AngularButton(title: "Results", icon: "chart.bar.xaxis")
                    .padding(.horizontal, 20)
            }
        }
    }

    private var bottomSection: some View {
        VStack(alignment: .center) {
            createButtons(buttonStatus: status)
                .padding(.top, 5)
            ProgressView(value: progression, total: 1.0)
                .tint(.blue)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
        }
    }

    // MARK: - Alerts

    private func displayAlert() -> Alert {
        Alert(
            title: Text("No Network"),
            message: Text("The is no Internet connection. Please make sure you have network and try again"),
            dismissButton: .default(Text("OK")) {
                status = .forecast
                progression = 0
            }
        )
    }

    // MARK: - Helper function

    private func multipleCallNetwork(numberOfCompanies: Double) {
        for company in allCompanies {
            network.fetchTweets(company: company, using: .arobase) { tags1 in
                progression += 0.33 / numberOfCompanies
                network.fetchTweets(company: company, using: .hash) { tags2 in
                    progression += 0.33 / numberOfCompanies
                    network.fetchData(company: company) { tags3 in
                        company.tags = tags1 + tags2 + tags3
                        progression += 0.34 / numberOfCompanies
                        callNumber += 1
                        print("\(callNumber) / \(allCompanies.count)")
                        if callNumber == allCompanies.count {
                            status = .results
                        }
                    }
                }
            }
        }
    }

    private func initializeView() {
        callNumber = 0
        status = .forecast
        progression = 0
    }

}
