import SwiftUI


struct EditView: View {
    @Bindable var countdown: Countdown
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if countdown.isScheduled {
                        DatePicker("Time and Date", selection: $countdown.date)
                            .datePickerStyle(.graphical)
                    } else {
                        LengthPicker(countdown: countdown)
                            .foregroundColor(.primary)
                    }
                }
                
                Section {
                    Toggle("Show Early Warning", isOn: $countdown.showsEarlyWarning)
                        .foregroundColor(.primary)
                    if countdown.showsEarlyWarning {
                        Picker(selection: $countdown.earlyWarningTime, label: Text("Trigger Time").foregroundColor(.primary)) {
                            ForEach([10, 9, 8, 7, 6, 5, 4, 3, 2], id: \.self) { minute in
                                Text("\(minute):00").tag(Double(minute * 60))
                            }
                        }
                    }
                }
                
                Section {
                    Toggle("Show Final Warning", isOn: $countdown.showsFinalWarning)
                        .foregroundColor(.primary)
                    if countdown.showsFinalWarning {
                        Picker(selection: $countdown.finalWarningTime, label: Text("Trigger Time").foregroundColor(.primary)) {
                            ForEach([5, 4, 3, 2, 1, 0], id: \.self) { minute in
                                Text("\(minute):00").tag(Double(minute * 60))
                            }
                        }
                        Toggle("Flash at 0:00", isOn: $countdown.finalWarningFlashes)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationBarTitle("Edit Timer", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
        }
        }
    }
}

// MARK: - Previews

#Preview("Countdown") {
    EditView(countdown: Countdown(Length(timeInterval: 300)))
}

#Preview("Scheduled") {
    EditView(countdown: Countdown(Date()))
}
