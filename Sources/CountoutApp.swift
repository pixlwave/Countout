import SwiftUI

@main
struct CountoutApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            AdaptiveSplitView()
        }
    }
}
