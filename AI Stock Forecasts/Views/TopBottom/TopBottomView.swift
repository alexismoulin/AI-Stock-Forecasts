import SwiftUI

struct TopBottomView: View {

    // MARK: - Properties

    let network = Networking()

    var sector: String
    var fetchRequest: FetchRequest<CustomCompany>
    var allCompanies: [Company]

    @State private var ready: Bool = false
    @State private var progression: Double = 0
    @State private var arrowType: ArrowType = .up

    @Environment(\.horizontalSizeClass) var sizeClass

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
    }

    // MARK: - body

    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.vertical)
            VStack(spacing: 5) {
                SectionTitle(
                    title: arrowType == .up ? "Top 5 companies" : "Bottom 5 companies",
                    subTitle: arrowType == .up ?
                        "Best stock outcomes for the sector"
                        : "Worst stock outcomes for the sector"
                )
                createSegmentedPicker()
                Spacer()
                Arrows(type: arrowType)
                Spacer()
                createButtons().padding(.top, 5)
                ProgressView(value: progression, total: 1.0).padding(5)
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

    // MARK: - Component functions

    private func createSegmentedPicker() -> some View {
        Picker(selection: $arrowType, label: Text("Arrow label")) {
            ForEach(ArrowType.allCases, id: \.self) {
                Text($0.rawValue.capitalized)
                    .font(.largeTitle)
            }
        }
        .padding(.vertical)
        .padding(.horizontal, sizeClass == .compact ? 12 : 60)
        .pickerStyle(SegmentedPickerStyle())
    }

    private func createButtons() -> some View {
        if !ready {
            return AnyView(Button {
                for company in allCompanies {
                    network.fetchTweets1(company: company.arobase) { arobaseScore in
                        network.fetchTweets2(company: company.hash) { hashScore in
                            network.fetchData(company: String(company.arobase.dropFirst())) { newsScore in
                                progression += 1.0 / Double(allCompanies.count)
                                company.arobaseScore = arobaseScore
                                company.hashScore = hashScore
                                company.newsScore = newsScore
                                ready = (progression > 0.999)
                            }
                        }
                    }
                }
            } label: {
                ButtonStyled(text: "forecast", color: .buttonColor)
            })
        } else {
            return AnyView(NavigationLink(destination: TopBottomResultsView(
                sector: sector,
                companyArray: allCompanies,
                type: arrowType
            )) {
                ButtonStyled(text: "results", color: Color.blue)
            })
        }
    }
}
