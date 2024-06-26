import SwiftUI

struct MainView: View {
    @Environment(Counter.self) private var counter
    @Environment(OutputDisplay.self) private var outputDisplay
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 18) {
            CountdownView()
                .aspectRatio(4 / 3, contentMode: .fit)
                .cornerRadius(15)
                .overlay(alignment: .bottom) {
                    missingDisplayNotice
                        .offset(x: 0, y: -10)
                        .opacity(outputDisplay.isConnected ? 0 : 1)
                }
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
                .padding(.horizontal)
                .disabled(counter.current.isScheduled)
                .disabled(counter.state == .finished)
                
                Button(action: minusOne) {
                    Image(systemName: "goforward.60")
                        .font(.title2)
                }
                .padding(.horizontal)
                .disabled(counter.current.isScheduled)
                .disabled(counter.remaining <= 60)
            }
            
            if horizontalSizeClass == .compact {
                TimersView()
                    .overlay(alignment: .top) { Divider() }
            } else {
                Spacer()
            }
        }
    }
    
    var missingDisplayNotice: some View {
        Text("Display not connected")
            .font(.caption)
            .foregroundColor(.red)
            .padding(.horizontal, 5)
            .background(.thickMaterial, in: Capsule())
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
