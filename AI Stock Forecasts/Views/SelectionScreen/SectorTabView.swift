import SwiftUI

struct SectorTabView: View {
    @Environment(\.managedObjectContext) private var moc
    
    var sector: String
    
    let fetchRequest: FetchRequest<CustomCompany>
    
    init(sector: String) {
        self.sector = sector
        fetchRequest = FetchRequest<CustomCompany>(
            entity: CustomCompany.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "sector == %@", sector),
            animation: nil
        )
    }
    
    var body: some View {
        TabView {
            SelectionView(sector: sector, fetchRequest: fetchRequest)
                .tabItem {
                    Image(systemName: "target")
                    Text("Single")
                }
            TopBottomView(sector: sector, type: .up, fetchRequest: fetchRequest)
                .tabItem {
                    Image(systemName: "chevron.up")
                    Text("Top 5")
                }
            TopBottomView(sector: sector, type: .down, fetchRequest: fetchRequest)
                .tabItem {
                    Image(systemName: "chevron.down")
                    Text("Bottom 5")
                }
            AddView(sector: sector)
                .tabItem {
                    Image(systemName: "plus")
                    Text("Add Company")
                }
        }
        .colorScheme(.light)
        .navigationTitle("\(sector.capitalized)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

