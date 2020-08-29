import Foundation

class CountdownTimer: ObservableObject {
    
    static let shared = CountdownTimer()
    
    enum State {
        case reset, active, paused, finished
    }
    
    @Published var currentTimer = Countdown(.timer(300)) {
        didSet { if state != .active { reset() } }
    }
    
    @Published var timerQueue = [Countdown]()
    
    @Published var endDate = Date().addingTimeInterval(300)
    
    @Published private(set) var remaining: TimeInterval = 300
    
    var runTimer: Timer?
    
    @Published private(set) var state = State.reset
    
    func start() {
        guard runTimer == nil, state != .finished else { return }
        
        switch currentTimer.value {
        case .timer(let length):
            guard state != .finished else { break }
            endDate = Date().addingTimeInterval(state == .paused ? remaining : length)
        case .schedule(let endDate):
            guard endDate > Date() else { break }
            self.endDate = endDate
        }
        
        runTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tick()
        }
        
        state = .active
    }
    
    func stop() {
        stopTimer()
        state = .paused
    }
    
    private func stopTimer() {
        runTimer?.invalidate()
        runTimer = nil
    }
    
    func reset() {
        stopTimer()
        
        switch currentTimer.value {
        case .timer(let length):
            remaining = length
        case .schedule(let endDate):
            remaining = endDate.timeIntervalSinceNow
        }
        
        state = .reset
    }
    
    func tick() {
        remaining = endDate.timeIntervalSinceNow
        
        if Date() > endDate {
            stopTimer()
            state = .finished
        }
    }
    
    func add(_ timeInterval: TimeInterval) {
        switch state {
        case .reset:
            state = .paused
            remaining += timeInterval   // add to remaining to allow resetting back to original length
        case .active:
            endDate.addTimeInterval(timeInterval)
            tick()
        case .paused, .finished:
            remaining += timeInterval
        }
    }
    
    func nextTimer() {
        guard timerQueue.count > 0 else { return }
        currentTimer = timerQueue.removeFirst()
    }
    
}
