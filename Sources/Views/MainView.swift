import SwiftUI

struct MainView: View {
    @ObservedObject var countdown = CountdownTimer.shared
    @ObservedObject var appearance = Appearance.shared
    @ObservedObject var outputDisplay = OutputDisplay.shared
    
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
            
            CountdownCell(countdown: countdown.currentTimer)
                .padding(.trailing)
            
            List {
                ForEach(countdown.timerQueue, id: \.self) { timer in
                    CountdownCell(countdown: timer)
                }
                .onDelete(perform: delete)
            }
            
            HStack {
                Button(action: countdown.start) {
                    Text("Start")
                        .font(.title2)
                }
                .disabled(countdown.state == .active)
                .disabled(countdown.state == .finished)
                .padding(.horizontal)
                
                Button(action: countdown.reset) {
                    Text("Reset")
                        .font(.title2)
                }
                .disabled(countdown.state == .reset)
                .padding(.horizontal)
                
                Button(action: countdown.stop) {
                    Text("Stop")
                        .font(.title2)
                }
                .disabled(countdown.state != .active)
                .padding(.horizontal)
            }
            
            HStack {
                Button(action: plusOne) {
                    Image(systemName: "gobackward.60")
                        .font(.title2)
                }.padding()
                
                Button(action: minusOne) {
                    Image(systemName: "goforward.60")
                        .font(.title2)
                }
                .padding()
                .disabled(countdown.remaining <= 60)
            }.padding(.top)
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            countdown.timerQueue.remove(at: index)
        }
    }
    
    func plusOne() {
        countdown.add(60)
    }
    
    func minusOne() {
        countdown.add(-60)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
