import SwiftUI

struct CustomCompanyList: View {
    
    @EnvironmentObject var dataController: DataController
    @FetchRequest(entity: CustomCompany.entity(), sortDescriptors: []) var customCompanies: FetchedResults<CustomCompany>
    
    var body: some View {
        List(customCompanies) { company in
            NavigationLink(destination: EditView(company: company)) {
                HStack {
                    Text(company.wrappedName)
                    Spacer()
                    Text(company.wrappedId)
                }
            }
        }
        .navigationTitle("Your custom companies")
        .navigationBarTitleDisplayMode(.inline)
    }
}
