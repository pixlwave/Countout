import SwiftUI

@main
struct CountoutApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    private let counter = Counter.shared
    private let appearance = Appearance.shared
    private let outputDisplay = OutputDisplay.shared
    
    init() {
        if let state = UserDefaults.standard.string(forKey: "Snapshot").flatMap(AppState.init) {
            configureScreenshot(state)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AdaptiveSplitView()
                .environment(counter)
                .environment(appearance)
                .environment(outputDisplay)
        }
    }
    
    func configureScreenshot(_ state: AppState) {
        outputDisplay.isConnected = true
        
        switch state {
        case .default:
            counter.mockDefaultState()
            appearance.reset()
        case .queue:
            counter.mockQueueState()
            appearance.reset()
        case .output:
            counter.mockOutputState()
            appearance.mockOutputState()
        case .appearance:
            counter.mockDefaultState()
            appearance.mockEditState()
        }
    }
}
