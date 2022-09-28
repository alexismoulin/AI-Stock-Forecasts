import Foundation

class Model: ObservableObject {
    // Tab Bar
    @Published var showTab: Bool = true

    // Navigation Bar
    @Published var showNav: Bool = true

    // Modal
    @Published var showModal: Bool = false
    @Published var dismissModal: Bool = false

    // Detail View
    @Published var showDetail: Bool = false
    @Published var selectedCourse: Int = 0
}
