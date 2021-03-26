import SwiftUI

struct DataPoint: Identifiable {
    let id: Int
    let value: Double
    let color: Color
    let title: String

    init(value: Double, color: Color, title: String = "") {
        self.id = Int.random(in: 1..<Int.max)
        self.value = value
        self.color = color
        self.title = title
    }

    init(id: Int, value: Double, color: Color, title: String = "") {
        self.id = id
        self.value = value
        self.color = color
        self.title = title
    }
}
