import SwiftUI

struct AnimatableProgressArc: Shape {

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: radius, y: radius)
        var path = Path()

        path.addArc(
            center: center,
            radius: radius - lineWidth / 2.0 - 1.0,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false)
        path = path.strokedPath(.init(lineWidth: lineWidth - 2.0))
        return path
    }

    var radius: CGFloat
    var lineWidth: CGFloat

    var startAngle: Angle
    var endAngle: Angle

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(startAngle.radians, endAngle.radians) }
        set {
            endAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }

}
