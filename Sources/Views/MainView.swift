import SwiftUI

struct MainView: View {
    @ObservedObject var counter = Counter.shared
    @ObservedObject var appearance = Appearance.shared
    @ObservedObject var outputDisplay = OutputDisplay.shared
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isPresentingAppearance = false
    
    var body: some View {
        VStack() {
            CountdownView()
                .cornerRadius(15)
                .overlay(Text("Display not connected")
                            .font(.caption)
                            .foregroundColor(.red)
                            .offset(x: -8, y: -5)
                            .opacity(outputDisplay.isConnected ? 0 : 1),
                         alignment: .bottomTrailing)
                .padding(.horizontal)
                .padding(.top, 8)
                .layoutPriority(1)
            
            HStack {
                Button(action: counter.start) {
                    Text("Start")
                        .font(.title2)
                }
                .disabled(counter.state == .active)
                .disabled(counter.state == .finished)
                .padding(.horizontal)
                
                Button(action: counter.reset) {
                    Text("Reset")
                        .font(.title2)
                }
                .disabled(counter.current.isScheduled)
                .disabled(counter.state == .reset)
                .padding(.horizontal)
                
                Button(action: counter.stop) {
                    Text("Stop")
                        .font(.title2)
                }
                .disabled(counter.state != .active)
                .padding(.horizontal)
            }
            
            HStack {
                Button(action: plusOne) {
                    Image(systemName: "gobackward.60")
                        .font(.title2)
                }
                .padding()
                .disabled(counter.current.isScheduled)
                
                Button { isPresentingAppearance.toggle() } label: {
                    Image(systemName: "paintpalette")
                }
                .padding()
                
                Button(action: minusOne) {
                    Image(systemName: "goforward.60")
                        .font(.title2)
                }
                .padding()
                .disabled(counter.current.isScheduled)
                .disabled(counter.remaining <= 60)
            }
            
            if horizontalSizeClass == .compact {
                CountdownQueue()
                    .overlay(Divider(), alignment: .top)
            } else {
                Spacer()
            }
        }
        .sheet(isPresented: $isPresentingAppearance) {
            AppearanceView(isPresented: $isPresentingAppearance)
        }
    }
    
    func plusOne() {
        counter.add(60)
    }
    
    func minusOne() {
        counter.add(-60)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
