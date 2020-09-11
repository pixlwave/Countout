import SwiftUI

@main
struct CountoutApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var countdown = CountdownTimer.shared
    
    @State private var isPresentingAppearance = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.background.ignoresSafeArea()
                
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
                                    countdown.queue.append(Countdown(Length(timeInterval: 300)))
                                }
                                Button("Scheduled") {
                                    countdown.queue.append(Countdown(Date().addingTimeInterval(300)))
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
                                countdown.nextCountdown()
                            } label: {
                                Image(systemName: "arrowtriangle.right.square")
                            }
                            .disabled(countdown.queue.isEmpty)
                        }
                    }
            }
        }
    }
}
