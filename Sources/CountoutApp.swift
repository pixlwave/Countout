import SwiftUI

@main
struct CountoutApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var tabSelection = 0
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
