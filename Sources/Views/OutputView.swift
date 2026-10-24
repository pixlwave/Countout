import SwiftUI
import Observation

#warning("Replace with a 2-way binding?")
@Observable class OutputDisplay {
    static let shared = OutputDisplay()
    var isConnected = false
}

struct OutputView: View {
    @Environment(OutputDisplay.self) private var outputDisplay
    
    var body: some View {
        CountdownView()
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true
                outputDisplay.isConnected = true
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
                outputDisplay.isConnected = false
            }
    }
}
