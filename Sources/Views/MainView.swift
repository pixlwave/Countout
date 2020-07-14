import SwiftUI

struct MainView: View {
    @ObservedObject var countdown = CountdownTimer.shared
    @ObservedObject var appearance = Appearance.shared
    
    @State private var countdownMinutes = CountdownTimer.shared.length / 60
    @State private var countdownSeconds = CountdownTimer.shared.length.truncatingRemainder(dividingBy: 60)
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
                Text("Length:")
                TextField("", value: $countdownMinutes, formatter: NumberFormatter())
                    .keyboardType(.numbersAndPunctuation)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 40)
                    .onChange(of: countdownMinutes) { _ in
                        updateLength()
                    }
                Text("minutes")
                    .font(.subheadline)
                    .padding(.trailing)
                TextField("", value: $countdownSeconds, formatter: NumberFormatter())
                    .keyboardType(.numbersAndPunctuation)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 40)
                    .onChange(of: countdownSeconds) { _ in
                        updateLength()
                    }
                Text("seconds")
                    .font(.subheadline)
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
    
    func updateLength() {
        countdown.length = (countdownMinutes.rounded() * 60) + countdownSeconds.rounded()
        
        if countdownSeconds > 59 {
            countdownMinutes = CountdownTimer.shared.length / 60
            countdownSeconds = CountdownTimer.shared.length.truncatingRemainder(dividingBy: 60)
        }
    }
    
    func plusOne() {
        countdown.add(60)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
