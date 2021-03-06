import SwiftUI
import VisualEffects

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
                        .padding(5)
                        .background(VisualEffectBlur(blurStyle: .systemThickMaterial)
                                        .clipShape(Circle()))
                }.offset(x: -23, y: 13), alignment: .topTrailing)
                .sheet(isPresented: $isPresentingAppearance) {
                    AppearanceView()
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
                        AppearanceView()
                    }
            }
        }
    }
}
