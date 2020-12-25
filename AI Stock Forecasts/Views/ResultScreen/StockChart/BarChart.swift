import SwiftUI

struct BarChart: View {
    let dataPoints: [DataPoint]
    let maxValue: Double
    
    init(dataPoints: [DataPoint]) {
        self.dataPoints = dataPoints
        let highestPoint = dataPoints.max { $0.value < $1.value }
        self.maxValue = highestPoint?.value ?? 1
    }
    
    var body: some View {
        ZStack {
            VStack {
                ForEach(1...10, id: \.self) { _ in
                    Divider()
                    Spacer()
                }
            }
            HStack {
                VStack {
                    ForEach((1...10).reversed(), id: \.self) { i in
                        Text(String(Int(Double(i) * maxValue / 10)))
                            .padding(.horizontal)
                            .animation(nil)
                        Spacer()
                    }
                }
                ForEach(dataPoints) { data in
                    VStack {
                        Rectangle()
                            .fill(data.color)
                            .scaleEffect(y: CGFloat(data.value / maxValue), anchor: .bottom)
                        Text(data.title)
                            .bold()
                            .padding(.bottom)
                    }
                }
            }
        }
    }
}
