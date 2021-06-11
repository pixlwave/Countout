import SwiftUI


struct EditView: View {
    @ObservedObject var countdown: Countdown
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditView(countdown: Countdown(Length(timeInterval: 300)))
        }
    }
}
