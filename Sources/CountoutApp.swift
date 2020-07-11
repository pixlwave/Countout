import SwiftUI

@main
struct CountoutApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                MainView()
                    .tabItem { Label("Countdown", systemImage: "stopwatch") }
                    .onAppear { CountdownTimer.shared.isScheduled = false }
                DateView()
                    .tabItem { Label("Schedule", systemImage: "calendar") }
                    .onAppear { CountdownTimer.shared.isScheduled = true }
            }
        }
    }
}
