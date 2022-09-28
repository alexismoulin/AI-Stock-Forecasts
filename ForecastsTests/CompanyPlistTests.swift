import XCTest
@testable import AI_Stock_Forecasts

class CompanyPlistTests: XCTestCase {

    func testLoadPlist() {
        do {
            let fullPlist: [BaseCompany] = try BaseCompany.loadAll()
            XCTAssertNotNil(fullPlist, "Not able to load the Plist")
        } catch {
            fatalError("Not able to load base companies")
        }
    }

    func testGetCompaniesFromSector() {
        for sector in SectorEnum.allCases {

            let companiesBySector = BaseCompany.loadSectorData(for: sector.rawValue)
            XCTAssertNotNil(companiesBySector, "Not able to load companies for sector: \(sector)")

            switch sector {
            case .industrials:
                XCTAssertEqual(companiesBySector?.count, 18)
            case .healthcare:
                XCTAssertEqual(companiesBySector?.count, 14)
            case .technology:
                XCTAssertEqual(companiesBySector?.count, 29)
            case .telecomMedia:
                XCTAssertEqual(companiesBySector?.count, 13)
            case .goods:
                XCTAssertEqual(companiesBySector?.count, 30)
            case .energy:
                XCTAssertEqual(companiesBySector?.count, 5)
            case .financials:
                XCTAssertEqual(companiesBySector?.count, 9)
            case .all:
                XCTAssertEqual(companiesBySector?.count, 118)
            }
        }
    }

    func testUniqueData() throws {
        let results = try BaseCompany.loadAll()
        let listOfIDs = results.map { $0.id }
        let uniqueIds = listOfIDs.uniqued()
        XCTAssertTrue(listOfIDs.elementsEqual(uniqueIds))
    }

}
