import Foundation

struct CompaniesModel {

    static func readPropertyList() -> [[String: String]]? {
        guard let path = Bundle.main.path(forResource: "companies", ofType: "plist") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let plist = try? PropertyListSerialization.propertyList(
                from: data, options: .mutableContainers, format: nil) as? [[String: String]]
        else { return nil }
        return plist
    }

    static func getAllCompaniesFromSector(for sector: String) -> [Company]? {
        if let fullPlist = readPropertyList() {
            var companyList: [Company] = []
            for company in fullPlist {
                if company["sector"] == sector || sector == "all" {
                    companyList.append(
                        Company(
                            id: company["id"] ?? "ERROR",
                            name: company["name"] ?? "ERROR",
                            arobase: company["arobase"] ?? "ERROR",
                            sector: company["sector"] ?? "ERROR",
                            custom: false
                        )
                    )
                }
            }
            return companyList
        }
        return nil
    }
}
