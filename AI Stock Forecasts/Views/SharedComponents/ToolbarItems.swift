import SwiftUI

var addCompanyToolbarItem: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
        NavigationLink(destination: EditView(company: nil)) {
            Label("Add Company", systemImage: "plus")
                .accessibilityElement()
                .accessibilityLabel("Add Company")
        }
    }
}
