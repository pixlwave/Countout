import SwiftUI

struct AdaptiveSplitView: View {
    @ObservedObject var appearance = Appearance.shared
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isPresentingAppearance = false
    
    var body: some View {
        if horizontalSizeClass == .compact {
            MainView()
                .overlay(Button { isPresentingAppearance.toggle() } label: {
                    Image(systemName: "paintbrush")
                        .font(.title3)
                        .foregroundColor(appearance.textColor)
                        .padding()
                        .padding(.trailing, 10)
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
                            Button { isPresentingAppearance.toggle() } label: {
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
