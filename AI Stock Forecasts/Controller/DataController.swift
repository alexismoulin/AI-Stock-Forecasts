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

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error.localizedDescription), \(error.userInfo)")
            }
        })
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
}
