import SwiftUI

struct AdaptiveSplitView: View {
    @ObservedObject var appearance = Appearance.shared
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isPresentingAppearance = false
    
    var body: some View {
        if horizontalSizeClass == .compact {
            MainView()
                .overlay(alignment: .topTrailing) {
                    appearanceOverlayButton
                        .offset(x: -23, y: 13)
                }
                .sheet(isPresented: $isPresentingAppearance) {
                    AppearanceView()
                }
        } else {
            NavigationSplitView {
                TimersView()
                    .navigationTitle("Timers")
            } detail: {
                MainView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem {
                            Button { isPresentingAppearance = true } label: {
                                Image(systemName: "paintbrush")
                            }
                        }
                    }
                    .sheet(isPresented: $isPresentingAppearance) {
                        AppearanceView()
                    }
            }
        }
    }
    
    var appearanceOverlayButton: some View {
        Button { isPresentingAppearance = true } label: {
            Image(systemName: "paintbrush")
                .font(.body)
                .padding(5)
                .background(.thickMaterial, in: Circle())
        }
    }
}
