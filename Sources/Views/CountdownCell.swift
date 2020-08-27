import SwiftUI

struct CountdownCell: View {
    @ObservedObject var countdown = CountdownTimer.shared
    
    @State private var countdownMinutes: TimeInterval = 5 //= countdown.current length / 60
    @State private var countdownSeconds: TimeInterval = 0 //= countdown.length.truncatingRemainder(dividingBy: 60)
    var body: some View {
        HStack {
            Text("minutes:")
                .font(Font.subheadline.weight(.thin))
            TextField("", value: $countdownMinutes, formatter: NumberFormatter())
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 60)
                .onChange(of: countdownMinutes) { _ in
                    updateLength()
                }
            Text("seconds:")
                .font(Font.subheadline.weight(.thin))
                .padding(.leading)
            TextField("", value: $countdownSeconds, formatter: NumberFormatter())
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 60)
                .onChange(of: countdownSeconds) { _ in
                    updateLength()
                }
        }
    }
    
    func updateLength() {
        let length = (countdownMinutes.rounded() * 60) + countdownSeconds.rounded()
        countdown.current = .countdown(length)
        
        #warning("Prevent countdownSeconds from being >59 instead of this???")
        if countdownSeconds > 59 {
            countdownMinutes = length / 60
            countdownSeconds = length.truncatingRemainder(dividingBy: 60)
        }
    }
}
