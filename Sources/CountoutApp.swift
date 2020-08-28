import SwiftUI

@main
struct CountoutApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var countdown = CountdownTimer.shared
    
    @State private var isPresentingAppearance = false
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .sheet(isPresented: $isPresentingAppearance) {
                    AppearanceView(isPresented: $isPresentingAppearance)
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            isPresentingAppearance.toggle()
                        } label: {
                            Image(systemName: "paintpalette")
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Spacer()
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Menu {
                            Button("Countdown") {
                                countdown.timerQueue.append(.countdown(300))
                            }
                            Button("Scheduled") {
                                countdown.timerQueue.append(.scheduled(Date().addingTimeInterval(300)))
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2)
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Spacer()
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            countdown.nextTimer()
                        } label: {
                            Image(systemName: "arrowtriangle.right.square")
                        }
                        .disabled(countdown.timerQueue.isEmpty)
                    }
                }
        }
    }
}
