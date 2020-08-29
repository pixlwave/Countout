import SwiftUI

struct DateCell: View {
    @ObservedObject var countdown: Countdown
    
    var body: some View {
        DatePicker("", selection: $countdown.date)
            .datePickerStyle(CompactDatePickerStyle())
            .frame(height: 50)
    }
}
