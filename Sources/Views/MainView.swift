import SwiftUI
import VisualEffects

struct MainView: View {
    @ObservedObject var counter = Counter.shared
    @ObservedObject var appearance = Appearance.shared
    @ObservedObject var outputDisplay = OutputDisplay.shared
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack() {
            CountdownView()
                .cornerRadius(15)
                .overlay(Text("Display not connected")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 5)
                            .background(VisualEffectBlur(blurStyle: .systemThickMaterial)
                                            .padding(.horizontal, -5)
                                            .clipShape(Capsule()))
                            .offset(x: 0, y: -10)
                            .opacity(outputDisplay.isConnected ? 0 : 1),
                         alignment: .bottom)
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
                .disabled(counter.state == .finished)
                
                Button(action: minusOne) {
                    Image(systemName: "goforward.60")
                        .font(.title2)
                }
                .padding()
                .disabled(counter.current.isScheduled)
                .disabled(counter.remaining <= 60)
            }
            
            if horizontalSizeClass == .compact {
                TimersView()
                    .overlay(Divider(), alignment: .top)
            } else {
                Spacer()
            }
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
