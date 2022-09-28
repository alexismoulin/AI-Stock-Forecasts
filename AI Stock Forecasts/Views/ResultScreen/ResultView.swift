import SwiftUI
import CoreHaptics

struct ResultView: View {

    // MARK: - Properties

    let stockData = StockData()
    var company: Company

    @EnvironmentObject var dataController: DataController
    @Environment(\.horizontalSizeClass) var sizeClass
    @EnvironmentObject var network: Networking
    @State private var engine = try? CHHapticEngine()
    @State var stockLogs: [StockLog] = []
    @State private var showDetails: Bool = false

    // MARK: - Screen Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ScrollView {
                    VStack(alignment: .center) {
                        CircleCard(company: company, height: geo.size.height * 0.8)
                            .padding(.top, 20)
                        if dataController.debugMode {
                            showDetailsButton
                        }
                        Divider()
                        if stockLogs.count < 12 {
                            ProgressView("loading data...")
                        } else {
                            StockCard(stockTitle: company.id, data: stockLogs)
                                .padding(.bottom, 40)
                        }
                    }
                }
                if sizeClass == .compact {
                    TabBar()
                }
            }
        }
        .navigationTitle(company.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(BackgroundBlob(style: .explore))
        .onAppear {
            performHaptics()
            stockData.getHistoricalData(stockSymbol: company.id) { results in
                stockLogs = results.suffix(12)
            }
        }
        .sheet(isPresented: $showDetails, onDismiss: nil) {
            DetailView(company: company)
        }
    }

    // MARK: - Components

    var showDetailsButton: some View {
        Button("Details") { showDetails = true }
        .buttonStyle(.borderedProminent)
    }

    var stockHistoryTitle: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("Daily stock price for ")
                .font(.title3)
                .fontWeight(.semibold)
            Text("\(company.id)")
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .font(.title2)
        }
    }

    // MARK: - Helper functions

    func performHaptics() {
        do {
            try engine?.start()
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
            let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

            let parameter = CHHapticParameterCurve(
                parameterID: .hapticIntensityControl,
                controlPoints: [start, end],
                relativeTime: 0
            )
            let event1 = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: 0
            )

            let event2 = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [sharpness, intensity],
                relativeTime: 0.125,
                duration: 1
            )

            let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Haptics failed: \(error.localizedDescription)")
        }
    }

}
