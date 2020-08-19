import SwiftUI

@main
struct CountoutApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var tabSelection = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabSelection) {
                MainView()
                    .tabItem { Label("Countdown", systemImage: "timer") }.tag(0)
                ScheduleView()
                    .tabItem { Label("Schedule", systemImage: "calendar") }.tag(1)
            }
            .onChange(of: tabSelection) { tabIndex in
                CountdownTimer.shared.isScheduled = tabIndex == 1
            }
        }
    }
}
