import XCTest
import CoreData
@testable import AI_Stock_Forecasts

class CoreDataTests: BaseTestCase {

    func testSaveCustomCompanyInCoreData() throws {
        let previousResults: Int = dataController.count(for: CustomCompany.fetchRequest())

        let company = CustomCompany(context: managedObjectContext)
        company.id = "AAA"
        company.name = "Company A"
        company.arobase = "@compA"
        company.sector = "industrials"
        dataController.save()

        let nextResults: Int = dataController.count(for: CustomCompany.fetchRequest())

        XCTAssertEqual(
            nextResults - previousResults,
            1,
            "Previous results: \(previousResults) - Next results: \(nextResults)"
        )
    }

    func testDeleteCompany() throws {
        try dataController.delete(id: "AAA")
        let results = try dataController.loadCustomCompany(id: "AAA")
        XCTAssertTrue(results.isEmpty)
    }

}
