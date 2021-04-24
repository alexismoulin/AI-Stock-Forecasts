import SwiftUI

struct DataPoint: Identifiable {
    let id = UUID()
    let value: Double
    let title: Int

    init(value: Double, title: Int = 0) {
        self.value = value
        self.title = title
    }
}
