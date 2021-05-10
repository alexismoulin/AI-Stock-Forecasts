import SwiftUI

struct DetailButton: View {
    let closure: () -> Void
    var body: some View {
        Button(action: closure) {
            Text("Details")
                .font(Font.system(size: 20.0, weight: .semibold, design: .rounded))
        }
            .padding(10)
            .overlay(Capsule().stroke(Color.blue, lineWidth: 3))
    }
}

struct DetailButton_Previews: PreviewProvider {
    static var previews: some View {
        DetailButton { }
    }
}
