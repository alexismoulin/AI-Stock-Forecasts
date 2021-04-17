import XCTest
@testable import AI_Stock_Forecasts

class CompanyPlistTests: XCTestCase {

    func testLoadPlist() {
        let fullPlist: [[String: String]]? = CompaniesModel.readPropertyList()
        XCTAssertNotNil(fullPlist, "Not able to load the Plist")
    }

    func testGetCompaniesFromSector() {
        for sector in SectorEnum.allCases {
            let companiesBySector = CompaniesModel.getAllCompaniesFromSector(for: sector.rawValue)
            XCTAssertNotNil(companiesBySector, "Not able to load companies for sector: \(sector)")

            if let safeCompanies = companiesBySector {
                for company in safeCompanies {
                    XCTAssertNotEqual(
                        company.id,
                        "ERROR",
                        "An Error company 'id' has been detected in sector: \(sector)"
                    )
                    XCTAssertNotEqual(
                        company.name,
                        "ERROR",
                        "An Error company 'name' has been detected in sector: \(sector)"
                    )
                    XCTAssertNotEqual(
                        company.arobase,
                        "ERROR",
                        "An Error company 'arobase' has been detected in sector: \(sector)"
                    )
                    XCTAssertNotEqual(
                        company.sector,
                        "ERROR",
                        "An Error company 'sector' has been detected in sector: \(sector)"
                    )
                }
            }
        }
    }

}
