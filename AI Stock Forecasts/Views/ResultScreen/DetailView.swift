import SwiftUI

struct DetailView: View {
    let company: Company
    @Binding var showDetails: Bool
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Subscores - Source: Twitter"), footer: Text("weight: 60%")) {
                    HStack {
                        Text("Score for ") + Text("\(company.arobase)").fontWeight(.bold).foregroundColor(.green)
                        Spacer()
                        Text("\(company.arobaseScore)").fontWeight(.bold).foregroundColor(.blue)
                    }
                    HStack {
                        Text("Score for ") + Text("\(company.hash)").fontWeight(.bold).foregroundColor(.green)
                        Spacer()
                        Text("\(company.hashScore)").fontWeight(.bold).foregroundColor(.blue)
                    }
                }
                Section(header: Text("Subscore - Source: News API"), footer: Text("weight: 40%")) {
                    HStack {
                        Text("Score for ") + Text("\(company.name)").fontWeight(.bold).foregroundColor(.green)
                        Spacer()
                        Text("\(company.newsScore)").fontWeight(.bold).foregroundColor(.blue)
                    }
                }
                Section(header: Text("Total")) {
                    HStack {
                        Text("Total Score :")
                        Spacer()
                        Text("\(Int(company.totalScore))").fontWeight(.black).foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Details for \(company.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { showDetails = false }
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(company: CompaniesModel.example, showDetails: .constant(true))
    }
}
