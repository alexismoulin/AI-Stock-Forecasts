import Foundation

extension String {
    mutating func clean(regex: String, with replacement: String = "") {
        self = self.replacingOccurrences(of: regex, with: replacement, options: .regularExpression, range: nil)
    }

    mutating func lowercasing() {
        self = self.lowercased()
    }

    mutating func removeRT() {
        if self.hasPrefix("rt") {
            self = String(self.dropFirst(2))
        }
    }

    mutating func removeEmojis() {
        var cleanedArray: [Character] = []
        for character in self where !character.isEmoji {
            cleanedArray.append(character)
        }
        self = String(cleanedArray)
    }
}

extension Character {
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}
