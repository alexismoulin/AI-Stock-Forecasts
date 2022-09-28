import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: String
    var tab: Tab
    var color: Color
}

var tabItems: [TabItem] = [
    TabItem(text: "Explore", icon: "magnifyingglass", tab: .explore, color: .teal),
    TabItem(text: "Best / Worst", icon: "arrow.up.arrow.down", tab: .topBottom, color: .blue),
    TabItem(text: "Edit Companies", icon: "square.and.pencil", tab: .edit, color: .red),
    TabItem(text: "Sectors", icon: "globe", tab: .sector, color: .pink)
]

enum Tab: String {
    case explore, topBottom, edit, sector
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }

}
