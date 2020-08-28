import SwiftUI

struct ScheduledCell: View {
    @ObservedObject var countdown = CountdownTimer.shared
    
    @State var endDate = Date().addingTimeInterval(5 * 60)
    var body: some View {
        DatePicker("", selection: $endDate)
            .datePickerStyle(CompactDatePickerStyle())
            .frame(height: 50)
            .onChange(of: endDate) { newValue in
                countdown.currentTimer = .scheduled(endDate)
            }
    }
}
