import SwiftUI

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
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.done)
                .frame(width: 50)
                .accessibilityIdentifier("Minutes Text Field")
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
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.done)
                .frame(width: 50)
                .accessibilityIdentifier("Seconds Text Field")
                .onChange(of: secondsString) { value in
                    if let seconds = Int(value), seconds >= 0 {
                        countdown.length.seconds = seconds
                    } else if value != "" {
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

struct LengthPicker_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            LengthPicker(countdown: Countdown(Length(timeInterval: 3600)))
        }
    }
}
