import SwiftUI


struct EditView: View {
    @ObservedObject var countdown: Countdown
    
    var body: some View {
        Form {
            Section {
                if countdown.isScheduled {
                    DatePicker("", selection: $countdown.date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                } else {
                    LengthPicker(countdown: countdown)
                        .foregroundColor(.primary)
                }
            }
            
            Section {
                Toggle("Show Early Warning", isOn: $countdown.showsEarlyWarning)
                if countdown.showsEarlyWarning {
                    Picker("Trigger Time", selection: $countdown.earlyWarningTime) {
                        ForEach(2..<11) { minute in
                            Text("\(minute):00").tag(Double(minute * 60))
                        }
                    }
                }
            }
            
            Section {
                Toggle("Show Final Warning", isOn: $countdown.showsFinalWarning)
                if countdown.showsFinalWarning {
                    Picker("Trigger Time", selection: $countdown.finalWarningTime) {
                        ForEach(0..<6) { minute in
                            Text("\(minute):00").tag(Double(minute * 60))
                        }
                    }
                    Toggle("Flash at 0:00", isOn: $countdown.finalWarningFlashes)
                }
            }
        }
    }
}


struct LengthPicker: View {
    @ObservedObject var countdown: Countdown
    
    var body: some View {
        HStack {
            Spacer()
            Text("minutes:")
                .font(Font.subheadline.weight(.thin))
            TextField("", value: $countdown.length.minutes, formatter: NumberFormatter())
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 60)
            Text("seconds:")
                .font(Font.subheadline.weight(.thin))
                .padding(.leading)
            TextField("", value: $countdown.length.seconds, formatter: NumberFormatter())
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 60)
        }
    }
}
