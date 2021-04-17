import SwiftUI

struct CustomCompanyList: View {

    // MARK: - Properties

    @EnvironmentObject var dataController: DataController
    @FetchRequest(
        entity: CustomCompany.entity(),
        sortDescriptors: []
    ) var customCompanies: FetchedResults<CustomCompany>

    // MARK: - Body

    var body: some View {
            Form {
                Section(header: Text("Custom companies you created")) {
                    List(customCompanies) { company in
                        NavigationLink(destination: EditView(company: company)) {
                            HStack {
                                Text(company.wrappedName)
                                Spacer()
                                Text(company.wrappedId)
                            }
                        }
                        .accessibilityLabel(company.wrappedName)
                    }
                }
            }
            .navigationTitle("Your custom companies")
            .toolbar {
                addCompanyToolbarItem
            }
    }
}
