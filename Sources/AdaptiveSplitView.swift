import SwiftUI

struct AdaptiveSplitView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact {
            MainView()
        } else {
            NavigationView {
                CountdownQueue()
                    .navigationTitle("Timers")
                MainView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationViewStyle(DoubleColumnNavigationViewStyle())
            }
        }
    }
}
