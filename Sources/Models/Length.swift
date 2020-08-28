import Foundation

struct Length: Equatable {
    var minutes: Int
    var seconds: Int {
        didSet {
            if seconds > 59 {
                let total = timeInterval
                minutes = Int((total / 60).rounded(.down))
                seconds = Int(total.truncatingRemainder(dividingBy: 60))
            }
        }
    }
    
    init(timeInterval: TimeInterval) {
        minutes = Int((timeInterval / 60).rounded(.down))
        seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
    }
    
    var timeInterval: TimeInterval { TimeInterval((minutes * 60) + seconds) }
}
