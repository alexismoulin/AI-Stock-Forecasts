import SwiftUI

struct AnimatableControlPointExterior: Shape {
    func path(in rect: CGRect) -> Path {
        let controlRadius = radius - lineWidth / 2.0 - 1.0
        let center = CGPoint(x: radius, y: radius)
        let x = center.x + controlRadius * CGFloat(cos(endAngle.radians))
        let y = center.y + controlRadius * CGFloat(sin(endAngle.radians))
        let pointCenter = CGPoint(x: x, y: y)

        let borderRect = CGRect(
            x: pointCenter.x - lineWidth / 2.0,
            y: pointCenter.y - lineWidth / 2.0,
            width: lineWidth + 2.0,
            height: lineWidth + 2.0
        )

        var path = Path()
        path.addEllipse(in: borderRect)

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

struct AnimatableControlPointInterior: Shape {
    func path(in rect: CGRect) -> Path {
        let controlRadius = radius - lineWidth / 2.0 - 1.0
        let center = CGPoint(x: radius, y: radius)
        let x = center.x + controlRadius * CGFloat(cos(endAngle.radians))
        let y = center.y + controlRadius * CGFloat(sin(endAngle.radians))
        let pointCenter = CGPoint(x: x, y: y)

        let rectangle = CGRect(
            x: pointCenter.x - lineWidth / 2.0 + 4.0,
            y: pointCenter.y - lineWidth / 2.0 + 4.0,
            width: lineWidth - 6.0,
            height: lineWidth - 6.0
        )

        var path = Path()
        path.addEllipse(in: rectangle)

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
