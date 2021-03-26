import SwiftUI
import Charts

struct Bar: UIViewRepresentable {
    var entries: [BarChartDataEntry]
    func makeUIView(context: Context) -> BarChartView {
        let chart = BarChartView()
        chart.legend.enabled = false
        chart.data = addData()
        return chart
    }

    func updateUIView(_ uiView: BarChartView, context: Context) {
        uiView.data = addData()
    }

    func addData() -> BarChartData {
        let data = BarChartData()
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.colors = [.systemGreen]
        dataSet.drawValuesEnabled = false
        data.addDataSet(dataSet)
        return data
    }

    typealias UIViewType = BarChartView

}
