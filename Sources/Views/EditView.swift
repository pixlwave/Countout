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
                Toggle("First Warning", isOn: $countdown.hasFirstWarning)
                if countdown.hasFirstWarning {
                    Picker("Warning Time", selection: $countdown.warningTime) {
                        ForEach(2..<11) { minute in
                            Text("\(minute):00").tag(Double(minute * 60))
                        }
                    }
                }
            }
            
            Section {
                Toggle("Second Warning", isOn: $countdown.hasSecondWarning)
                if countdown.hasSecondWarning {
                    Picker("Warning Time", selection: $countdown.secondWarningTime) {
                        ForEach(0..<6) { minute in
                            Text("\(minute):00").tag(Double(minute * 60))
                        }
                    }
                    Toggle("Flash", isOn: $countdown.flashWhenFinished)
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
