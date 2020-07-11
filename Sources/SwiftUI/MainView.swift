import SwiftUI

struct MainView: View {
    @ObservedObject var countdown = CountdownTimer.shared
    @ObservedObject var appearance = Appearance.shared
    
    @State private var lengthInMinutes = CountdownTimer.shared.length / 60
    @State private var isPresentingAppearance = false
    var hasDisplayConnected = false
    
    var body: some View {
        VStack() {
            CountdownView()
                .cornerRadius(15)
                .overlay(Text("Display not connected")
                            .font(.caption)
                            .foregroundColor(.red)
                            .offset(x: -8, y: -5)
                            .opacity(hasDisplayConnected ? 0 : 1),
                         alignment: .bottomTrailing)
                .padding(.horizontal)
            
            HStack {
                Text("Length")
                TextField("Length", value: $lengthInMinutes, formatter: NumberFormatter())
                    .keyboardType(.numbersAndPunctuation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 75)
                    .onChange(of: lengthInMinutes) { value in
                        countdown.length = lengthInMinutes.rounded() * 60
                    }
                #warning("Add a length in seconds field")
            }
            
            Spacer()
            
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
            
            Button(action: plusOne) {
                Label("Add 1 Minute", systemImage: "hourglass.badge.plus")
            }.padding()
            
            Button(action: { isPresentingAppearance.toggle() }) {
                Label("Appearance", systemImage: "eyedropper")
            }
            
            Spacer()
        }
        .sheet(isPresented: $isPresentingAppearance) {
            AppearanceView(isPresented: $isPresentingAppearance)
        }
    }
    
    func plusOne() {
        #warning("Re-enable the reset button if not yet started")
        countdown.add(60)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
