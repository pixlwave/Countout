import SwiftUI

struct CountdownCell: View {
    @ObservedObject var countdown: Countdown
    
    var body: some View {
        if countdown.isScheduled {
            DateCell(countdown: countdown)
        } else {
            LengthCell(countdown: countdown)
        }
    }
}
