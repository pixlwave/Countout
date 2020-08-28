import SwiftUI

struct TimerCell: View {
    let timer: CountdownTimer.TimerValue
    
    var body: some View {
        switch timer {
        case .countdown:
            CountdownCell()
        case .scheduled:
            ScheduledCell()
        }
    }
}
