import CoreData

/// An environment singleton responsible for managing our core data stack,
/// including saving, deleting and dealing with sample data.
class DataController: ObservableObject {

    /// The CoreData container used to store our data
    let container: NSPersistentContainer

    /// Initializes a data controller either in memory (for temporary use such as testing or previewing),
    /// or on permanent storage (for use in regular apps).
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store data in temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CustomCompanies")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error.localizedDescription), \(error.userInfo)")
            }

            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
            }
            #endif
        }
    }

    /// Saves our Core Data context iff there is any changes. This silently ignores any error
    /// caused by saving, but this should be fine as our attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    /// Deletes an object from the Core Data stack
    /// - Parameter object: any NSManagedObject saved in our Core Data stack
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    /// Count the number of elements (generic) in the Core data stack
    /// - Parameter fetchRequest: Fetch request on a generic type
    /// - Returns: Number of elements
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    /// Deletes all custom companies from the core Data stack
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CustomCompany.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? container.viewContext.execute(batchDeleteRequest)
    }

    /// Creates dummy data used for app screenshots on the Apple Store
    func createDummyData() {

        let vow = CustomCompany(context: container.viewContext)
        vow.id = "VOW.DE"
        vow.name = "VolksWagen"
        vow.arobase = "@VolksWagen"
        vow.sector = "industrials"

        let btc = CustomCompany(context: container.viewContext)
        btc.id = "BTC-USD"
        btc.name = "Bitcoin USD"
        btc.arobase = "@bitcoin"
        btc.sector = "financials"

        let fubo = CustomCompany(context: container.viewContext)
        fubo.id = "FUBO"
        fubo.name = "FuboTV Inc."
        fubo.arobase = "@fubo"
        fubo.sector = "telecom-media"

        let levi = CustomCompany(context: container.viewContext)
        levi.id = "LEVI"
        levi.name = "Levi Strauss & Co."
        levi.arobase = "@levi"
        levi.sector = "goods"

        let airbus = CustomCompany(context: container.viewContext)
        airbus.id = "AIR.PA"
        airbus.name = "Airbus"
        airbus.arobase = "@Airbus"
        airbus.sector = "industrials"

        save()
    }
}
