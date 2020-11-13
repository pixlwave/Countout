import SwiftUI


struct EditView: View {
    @ObservedObject var countdown: Countdown
    @Environment(\.presentationMode) var presentationMode
    
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


struct LengthPicker: View {
    @ObservedObject var countdown: Countdown
    
    #warning("Using strings until number formatter updates without hitting return")
    @State private var minutesString = "5"
    @State private var secondsString = "0"
    
    var body: some View {
        HStack {
            Spacer()
            Text("Minutes:")
            TextField("", text: $minutesString)
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 50)
                .onChange(of: minutesString) { value in
                    if let minutes = Int(value), minutes >= 0 {
                        countdown.length.minutes = minutes
                    } else if value != "" {
                        reloadStrings()
                    }
                }
            Text("Seconds:")
                .padding(.leading)
            TextField("", text: $secondsString)
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 50)
                .onChange(of: secondsString) { value in
                    if let seconds = Int(value), seconds >= 0 {
                        countdown.length.seconds = seconds
                    } else if value != "" {
                        reloadStrings()
                    }
                }
        }
        .onAppear {
            reloadStrings()
        }
    }
    
    func reloadStrings() {
        minutesString = "\(countdown.length.minutes)"
        secondsString = "\(countdown.length.seconds)"
    }
}


struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditView(countdown: Countdown(Length(timeInterval: 300)))
        }
    }
}
