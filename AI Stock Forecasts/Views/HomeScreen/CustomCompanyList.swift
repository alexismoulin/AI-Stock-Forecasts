import SwiftUI

struct CustomCompanyList: View {
    
    @EnvironmentObject var dataController: DataController
    @FetchRequest(entity: CustomCompany.entity(), sortDescriptors: []) var customCompanies: FetchedResults<CustomCompany>
    
    var body: some View {
        VStack {
            SectionTitle(title: "Your custom companies", subTitle: "List of all the custom companies you created")
            List(customCompanies) { company in
                NavigationLink(destination: EditView(company: company)) {
                    HStack {
                        Text(company.wrappedName)
                        Spacer()
                        Text(company.wrappedId)
                    }
                }
            }
        }
    }
}
