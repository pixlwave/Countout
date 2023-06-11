import SwiftUI

struct AdaptiveSplitView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(Appearance.self) private var appearance
    @State private var isPresentingAppearance = false
    
    var body: some View {
        if horizontalSizeClass == .compact {
            MainView()
                .overlay(alignment: .topTrailing) {
                    appearanceOverlayButton
                        .offset(x: -23, y: 13)
                }
                .sheet(isPresented: $isPresentingAppearance) {
                    AppearanceView(appearance: appearance)
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
                        AppearanceView(appearance: appearance)
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
