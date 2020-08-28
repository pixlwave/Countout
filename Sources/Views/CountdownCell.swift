import SwiftUI

struct CountdownCell: View {
    @ObservedObject var countdown = CountdownTimer.shared
    @State private var length: Length = Length(timeInterval: 5 * 60)
    
    var body: some View {
        HStack {
            Spacer()
            
            Text("minutes:")
                .font(Font.subheadline.weight(.thin))
            TextField("", value: $length.minutes, formatter: NumberFormatter())
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 60)
            Text("seconds:")
                .font(Font.subheadline.weight(.thin))
                .padding(.leading)
            TextField("", value: $length.seconds, formatter: NumberFormatter())
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 60)
        }
        .onChange(of: length) { _ in
            countdown.currentTimer = .countdown(length.timeInterval)
        }
    }
}
