import Foundation

class CountdownTimer: NSObject {
    
    static let sharedClient = CountdownTimer()
    
    var delegate: CountdownTimerDelegate?
    var length = 0 { didSet { remaining = length } }
    private(set) var remaining = 0
    var runTimer: NSTimer?
    
    func start() {
        if runTimer == nil && remaining != 0 {
            runTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        }
    }
    
    func stop() {
        runTimer?.invalidate()
        runTimer = nil
    }
    
    func reset() {
        stop()
        remaining = length
        
        delegate?.countdownHasChanged()
    }
    
    func isActive() -> Bool {
        return runTimer != nil
    }
    
    func tick() {
        remaining -= 1
        delegate?.countdownHasChanged()
        
        if remaining == 0 {
            stop()
            delegate?.countdownHasFinished()
        }
    }
    
    func addToRemaining(amount: Int) {
        remaining += amount
        
        if remaining < 0 {
            stop()
            remaining = 0
            delegate?.countdownHasChanged()
            delegate?.countdownHasFinished()
        } else {
            delegate?.countdownHasChanged()
        }
    }
    
}

// MARK: CountdownTimerDelegate
protocol CountdownTimerDelegate {
    func countdownHasChanged()
    func countdownHasFinished()
}
