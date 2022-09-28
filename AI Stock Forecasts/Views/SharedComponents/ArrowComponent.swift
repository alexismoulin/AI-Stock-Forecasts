import SwiftUI

struct ArrowComponent: View {

    @Binding var arrowType: ArrowType

    var body: some View {
        GeometryReader { geo in
            VStack {
                upArrow(size: geo.size.height / 3)
                separator
                downArrow(size: geo.size.height / 3)
            }
            .frame(maxHeight: .infinity)
            .rotation3DEffect(arrowType == .up ? .degrees(0) : .degrees(180), axis: (1, 0, 0))
        }
    }

    // MARK: - components

    var separator: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .foregroundStyle(arrowType == .up ? .green : .red)
            .frame(width: 170, height: 30, alignment: .center)
    }

    func upArrow(size: CGFloat) -> some View {
        Image(systemName: "shift.fill")
            .symbolRenderingMode(.palette)
            .foregroundStyle(arrowType == .up ? .green : .red)
            .font(.system(size: size))
            .frame(maxWidth: .infinity, minHeight: size, alignment: .center)
    }

    func downArrow(size: CGFloat) -> some View {
        Image(systemName: "shift.fill")
            .rotationEffect(.degrees(180))
            .symbolRenderingMode(.palette)
            .foregroundStyle(.gray.opacity(0.5))
            .font(.system(size: size))
            .frame(maxWidth: .infinity, minHeight: size, alignment: .center)
    }
}

struct ArrowComponent_Previews: PreviewProvider {
    static var previews: some View {
        ArrowComponent(arrowType: .constant(.up))
    }
}
