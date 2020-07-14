import SwiftUI

struct ScheduleView: View {
    @ObservedObject var countdown = CountdownTimer.shared
    @ObservedObject var appearance = Appearance.shared
    @ObservedObject var outputDisplay = OutputDisplay.shared
    
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
            
            DatePicker("Date", selection: $countdown.endDate, displayedComponents: .hourAndMinute)
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(height: 50)
            
            Spacer()
            
            Button(action: { isPresentingAppearance.toggle() }) {
                Label("Appearance", systemImage: "eyedropper")
            }
            
            Spacer()
        }
        .onChange(of: countdown.endDate) { newValue in
            if countdown.state != .active {
                countdown.startScheduledTick()
            }
        }
        .sheet(isPresented: $isPresentingAppearance) {
            AppearanceView(isPresented: $isPresentingAppearance)
        }
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
