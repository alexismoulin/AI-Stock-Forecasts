import Foundation
import CoreData

// Not used for now
class EditViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

    let dataController: DataController
    var selectedCompany: CustomCompany?

    private let customCompanyController: NSFetchedResultsController<CustomCompany>
    @Published var fetchedCustomCompanies: [CustomCompany] = []
    @Published var listOfUniqueSymbols: [String] = []

    @Published var companyName: String = ""
    @Published var stockSymbol: String = ""
    @Published var arobase: String = "@"
    @Published var sector: SectorEnum = .all
    @Published var colorName: String = "Midnight"

    init(dataController: DataController, selectedCompany: CustomCompany?) {
        self.dataController = dataController
        self.selectedCompany = selectedCompany

        let request: NSFetchRequest<CustomCompany> = CustomCompany.fetchRequest()
        request.sortDescriptors = []
        customCompanyController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: dataController.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        customCompanyController.delegate = self

        do {
            try customCompanyController.performFetch()
            fetchedCustomCompanies = customCompanyController.fetchedObjects ?? []
            listOfUniqueSymbols = fetchedCustomCompanies.map { $0.wrappedId }
        } catch {
            print("Failed to fetch custom companies: \(error.localizedDescription)")
        }

    }

    func addCompany() {
        let company = CustomCompany(context: dataController.container.viewContext)
        company.name = companyName
        company.id = stockSymbol
        company.arobase = arobase
        company.sector = sector.rawValue
        company.colorName = colorName
        dataController.save()
    }

    func modifyCompany() {
        selectedCompany?.name = companyName
        selectedCompany?.id = stockSymbol
        selectedCompany?.arobase = arobase
        selectedCompany?.sector = sector.rawValue
        selectedCompany?.colorName = colorName
        dataController.save()
    }

    func saveCustomCompany() {
        if selectedCompany != nil {
            modifyCompany()
        } else {
            addCompany()
        }
    }
}
