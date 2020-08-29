import SwiftUI

struct DateCell: View {
    @ObservedObject var countdown: Countdown
    @State private var date = Date().addingTimeInterval(5 * 60)
    
    var body: some View {
        DatePicker("", selection: $date)
            .datePickerStyle(CompactDatePickerStyle())
            .frame(height: 50)
            .onChange(of: date) { newValue in
                countdown.value = .date(date)
            }
    }
}
