import SwiftUI

struct AdaptiveSplitView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Namespace private var namespace
    @Environment(Appearance.self) private var appearance
    @State private var isPresentingAppearance = false
    private let appearanceSheetID = "AppearanceSheet"
    
    var body: some View {
        if horizontalSizeClass == .compact {
            MainView()
                .overlay(alignment: .topTrailing) {
                    appearanceOverlayButton
                        .offset(x: -23, y: 13)
                }
                .sheet(isPresented: $isPresentingAppearance) {
                    AppearanceView(appearance: appearance)
                        .navigationTransition(.zoom(sourceID: appearanceSheetID, in: namespace))
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
                            .matchedTransitionSource(id: appearanceSheetID, in: namespace)
                        }
                    }
                    .sheet(isPresented: $isPresentingAppearance) {
                        AppearanceView(appearance: appearance)
                            .navigationTransition(.zoom(sourceID: appearanceSheetID, in: namespace))
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
        .matchedTransitionSource(id: appearanceSheetID, in: namespace)
    }
}
