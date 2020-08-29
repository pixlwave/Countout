import SwiftUI

struct CountdownCell: View {
    let countdown: Countdown
    
    var body: some View {
        switch countdown.value {
        case .timer:
            TimerCell()
        case .schedule:
            ScheduledCell()
        }
    }
}
