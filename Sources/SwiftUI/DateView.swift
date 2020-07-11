import SwiftUI

struct DateView: View {
    @ObservedObject var countdown = CountdownTimer.shared
    @ObservedObject var appearance = Appearance.shared
    
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
            
            DatePicker("Date", selection: $countdown.endDate, displayedComponents: .hourAndMinute)
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(height: 50)
            
            Spacer()
            
            Button(action: { isPresentingAppearance.toggle() }) {
                Label("Appearance", systemImage: "eyedropper")
            }
            
            Spacer()
        }
        .sheet(isPresented: $isPresentingAppearance) {
            AppearanceView(isPresented: $isPresentingAppearance)
        }
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView()
    }
}
