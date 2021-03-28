import XCTest
import CoreData
@testable import AI_Stock_Forecasts

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController()
        managedObjectContext = dataController.container.viewContext
    }

}
