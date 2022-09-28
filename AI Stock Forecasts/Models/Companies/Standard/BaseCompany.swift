import Foundation

struct BaseCompany: Identifiable, Hashable, Codable {

    // MARK: - base properties

    let arobase: String
    let id: String
    let name: String
    let sector: String

    static let example = BaseCompany(
        arobase: "@BestBuy",
        id: "BBY",
        name: "Best Buy Co., Inc.",
        sector: "goods"
    )

    static func loadAll() throws -> [BaseCompany] {
        // load the plist data
        guard  let path     = Bundle.main.path(forResource: "companies", ofType: "plist"),
               let xml      = FileManager.default.contents(atPath: path)
        else { fatalError("Not able to load companies.plist") }
        // insure conformance to BaseCompany struct
        let fullList: [BaseCompany] = try PropertyListDecoder().decode([BaseCompany].self, from: xml)
        return fullList
    }

    static func loadSectorData(for sector: String) -> [BaseCompany]? {
        guard let fullList = try? loadAll() else { return nil }
        if sector == SectorEnum.all.rawValue { return fullList }
        let shortList = fullList.filter { $0.sector == sector }
        if shortList.isEmpty {
            return nil
        } else {
            return shortList
        }
    }
}
