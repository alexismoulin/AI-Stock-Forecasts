import SwiftUI

struct CustomPickerTextView: View {

    @Binding var presentPicker: Bool
    @Binding var fieldString: String

    var placeholder: String

    var body: some View {
        TextField(placeholder, text: $fieldString)
            .disabled(true)
            .overlay(
                Button {
                    withAnimation {
                        presentPicker = true
                    }
                } label: {
                    Rectangle().foregroundColor((Color.clear))
                }
            ).colorScheme(.light)
    }
}
