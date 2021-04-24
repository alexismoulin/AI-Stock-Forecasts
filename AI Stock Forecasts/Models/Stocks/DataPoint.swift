import SwiftUI

struct DataPoint: Identifiable {
    let id = UUID()
    let value: Double
    let day: Int

    init(value: Double, day: Int = 0) {
        self.value = value
        self.day = day
    }
}
