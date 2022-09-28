import SwiftUI

struct BackgroundBlob: View {

    let appearBackground: Bool = true
    let style: Tab

    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            Image("Blob 1")
                .offset(x: blobPositionner(style: style).horizontal, y: blobPositionner(style: style).vertical)
                .opacity(appearBackground ? 1 : 0)
                .offset(y: appearBackground ? -10 : 0)
                .blur(radius: appearBackground ? 0 : 40)
                .hueRotation(.degrees(blobPositionner(style: style).hue))
                .allowsHitTesting(false)
                .accessibility(hidden: true)
        }.frame(maxHeight: .infinity)
    }

    private struct BlobParameters {
        var horizontal: CGFloat
        var vertical: CGFloat
        var hue: Double
    }

    private func blobPositionner(style: Tab) -> BlobParameters {
        switch style {
        case .explore:
            return BlobParameters(horizontal: 170, vertical: -60, hue: 0)
        case .topBottom:
            return BlobParameters(horizontal: -100, vertical: -60, hue: 30)
        case .edit:
            return BlobParameters(horizontal: -180, vertical: 300, hue: -70)
        case .sector:
            return BlobParameters(horizontal: 20, vertical: -150, hue: 130)
        }
    }
}

struct BackgroundBlob_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BackgroundBlob(style: .explore)
            BackgroundBlob(style: .topBottom)
            BackgroundBlob(style: .edit)
            BackgroundBlob(style: .sector)
        }
    }
}
