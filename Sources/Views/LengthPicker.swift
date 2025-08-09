import SwiftUI

struct LengthPicker: View {
    let countdown: Countdown
    
    #warning("Using strings until number formatter updates without hitting return")
    @State private var minutesString = "5"
    @State private var secondsString = "0"
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("Minutes:")
            TextField("", text: $minutesString)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.done)
                .padding(.vertical, -7) // Match the label height.
                .frame(width: 50)
                .accessibilityIdentifier("Minutes Text Field")
                .onChange(of: minutesString) { _, newValue in
                    if let minutes = Int(newValue), minutes >= 0 {
                        countdown.length.minutes = minutes
                    } else if newValue != "" {
                        reloadStrings()
                    }
                }
            
            Text("Seconds:")
                .padding(.leading)
            TextField("", text: $secondsString)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.done)
                .padding(.vertical, -7) // Match the label height.
                .frame(width: 50)
                .accessibilityIdentifier("Seconds Text Field")
                .onChange(of: secondsString) { _, newValue in
                    if let seconds = Int(newValue), seconds >= 0 {
                        countdown.length.seconds = seconds
                    } else if newValue != "" {
                        reloadStrings()
                    }
                }
        }
        .onAppear(perform: reloadStrings)
    }
    
    func reloadStrings() {
        minutesString = "\(countdown.length.minutes)"
        secondsString = "\(countdown.length.seconds)"
    }
}

// MARK: - Previews

#Preview {
    Form {
        LengthPicker(countdown: Countdown(Length(timeInterval: 3600)))
    }
}
