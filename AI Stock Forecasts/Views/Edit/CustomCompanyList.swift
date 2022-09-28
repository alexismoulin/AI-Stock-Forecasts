import SwiftUI
import CoreData

struct CustomCompanyList: View {

    // MARK: - Properties

    @FetchRequest(
        entity: CustomCompany.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \CustomCompany.sector, ascending: true),
            NSSortDescriptor(keyPath: \CustomCompany.name, ascending: true)
        ]
    ) var customCompanies: FetchedResults<CustomCompany>

    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var companyToEdit: CustomCompany?

    var listOfSymbols: [String] {
        customCompanies.map { $0.wrappedId }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(customCompanies) { company in
                        OverviewCustom(company: company)
                            .accessibilityLabel(company.wrappedName)
                            .scaleEffect(companyToEdit == company ? 1.02 : 1)
                            .onTapGesture {
                                companyToEdit = company
                            }
                    }
                    NavigationLink(destination: AddView(alreadyUsedSymbols: listOfSymbols)) {
                        AngularButton(title: "Add a Company", icon: "plus.circle.fill")
                            .padding(30)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(BackgroundBlob(style: .edit))
        }
        .navigationTitle("Your custom companies")
        .sheet(item: $companyToEdit) { company in
            EditView(company: company)
                .wrappedNavigationViewToMakeDismissable { companyToEdit = nil }
        }
    }
}
