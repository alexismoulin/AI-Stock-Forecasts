import Foundation

class Company: Identifiable {

    struct Tag: Identifiable, Hashable {
        var id = UUID()
        var source: Source
        var text: String
    }

    class Tags {
        var buyTags: [Tag]
        var holdTags: [Tag]
        var sellTags: [Tag]

        init(buyTags: [Tag]=[], holdTags: [Tag]=[], sellTags: [Tag] = []) {
            self.buyTags = buyTags
            self.holdTags = holdTags
            self.sellTags = sellTags
        }

        static func + (lhs: Tags, rhs: Tags) -> Tags {
            let sumTags = Tags()
            sumTags.buyTags = lhs.buyTags + rhs.buyTags
            sumTags.sellTags = lhs.sellTags + rhs.sellTags
            sumTags.holdTags = lhs.holdTags + rhs.holdTags
            return sumTags
        }

        static let example = Tags(
            buyTags: [
                Tag(source: .newsAPI, text: "Goog"),
                Tag(source: .twitterArobase, text: "Good"),
                Tag(source: .twitterHash, text: "Good"),
                Tag(source: .twitterArobase, text: "Good")
            ],
            holdTags: [Tag(source: .twitterArobase, text: "Neural"), Tag(source: .newsAPI, text: "Neutral")],
            sellTags: [Tag(source: .newsAPI, text: "Bad"), Tag(source: .twitterArobase, text: "Bad")])

    }

    // MARK: - base properties

    let id: String
    let name: String
    let arobase: String
    let sector: String
    let colorName: String?
    let custom: Bool

    // MARK: - special properties

    var tags = Tags()

    // MARK: - Calculated properties

    var hash: String {
        "#\(id)"
    }

    // score from [-100, 100]
    var totalScore: Double {
        if allTags == 0 {
            return 0
        } else {
            let partialscore = (tags.buyTags.count - tags.sellTags.count) * 100
            return Double(partialscore) / Double(allTags)
        }
    }

    // maps [-100, 100] range to [0, 1] range
    var calculatedScore: Double {
        (totalScore + 100.0) / 200.0
    }

    var allTags: Int {
        tags.buyTags.count + tags.holdTags.count + tags.sellTags.count
    }

    // MARK: - init

    init(baseCompany: BaseCompany) {
        self.id = baseCompany.id
        self.name = baseCompany.name
        self.arobase = baseCompany.arobase
        self.sector = baseCompany.sector
        self.colorName = nil
        self.custom = false
    }

    init(customCompany: CustomCompany) {
        self.id = customCompany.wrappedId
        self.name = customCompany.wrappedName
        self.arobase = customCompany.wrappedArobase
        self.sector = customCompany.wrappedSector
        self.colorName = customCompany.wrappedColorName
        self.custom = true
    }

    // MARK: - methods

    func resetScore() {
        self.tags = Tags()
    }

    // MARK: - Example

    static let example = Company(
        baseCompany: BaseCompany(
            arobase: "@AMD",
            id: "AMD",
            name: "Advanced Micro Devices",
            sector: "technology"
        )
    )

}
