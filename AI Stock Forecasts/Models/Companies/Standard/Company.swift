import Foundation

class Company: Identifiable {

    let id: String
    let name: String
    let arobase: String
    let sector: String
    let custom: Bool

    var hashScore: Int = 0
    var arobaseScore: Int = 0
    var newsScore: Int = 0

    var hash: String {
        "#\(id)"
    }

    var totalScore: Double {
        Double(hashScore) * 0.5 + Double(arobaseScore) * 0.5 + Double(newsScore) * 2
    }

    init(id: String, name: String, arobase: String, sector: String, custom: Bool) {
        self.id = id
        self.name = name
        self.arobase = arobase
        self.sector = sector
        self.custom = custom
    }

}
