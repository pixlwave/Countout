import SwiftUI

struct AdaptiveSplitView: View {
    @ObservedObject var appearance = Appearance.shared
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isPresentingAppearance = false
    
    var body: some View {
        if horizontalSizeClass == .compact {
            MainView()
                .overlay(Button { isPresentingAppearance = true } label: {
                    Image(systemName: "paintbrush")
                        .font(.body)
                        .foregroundColor(appearance.backgroundColor)
                        .padding()
                        .background(Circle()
                                        .padding(11)
                                        .foregroundColor(appearance.textColor))
                        .offset(x: -12, y: 2)
                }, alignment: .topTrailing)
                .sheet(isPresented: $isPresentingAppearance) {
                    AppearanceView(isPresented: $isPresentingAppearance)
                }
        } else {
            NavigationView {
                TimersView()
                    .navigationTitle("Timers")
                MainView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationViewStyle(DoubleColumnNavigationViewStyle())
                    .toolbar {
                        ToolbarItem {
                            Button { isPresentingAppearance = true } label: {
                                Image(systemName: "paintbrush")
                            }
                        }
                    }
                    .sheet(isPresented: $isPresentingAppearance) {
                        AppearanceView(isPresented: $isPresentingAppearance)
                    }
            }
        }
    }
}
