import SwiftUI

struct LengthCell: View {
    @ObservedObject var countdown: Countdown
    
    var body: some View {
        HStack {
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
