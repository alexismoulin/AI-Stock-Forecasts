import SwiftUI

extension View {

    @ViewBuilder
    func wrappedNavigationViewToMakeDismissable(_ dismiss: (() -> Void)?) -> some View {
        NavigationView {
            self
                .navigationBarTitleDisplayMode(.inline)
                .dismissable(dismiss)
        }.navigationViewStyle(StackNavigationViewStyle())
    }

    @ViewBuilder
    func dismissable(_ dismiss: (() -> Void)?) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
            self
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { dismiss() }
                    }
                }
        } else {
            self
        }
    }

}
