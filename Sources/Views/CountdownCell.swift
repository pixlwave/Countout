import SwiftUI

struct CountdownCell: View {
    @ObservedObject var countdown: Countdown
    
    var body: some View {
        switch countdown.value {
        case .length:
            LengthCell(countdown: countdown)
        case .date:
            DateCell(countdown: countdown)
        }
    }
}
