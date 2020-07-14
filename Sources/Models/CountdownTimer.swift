import Foundation

class CountdownTimer: ObservableObject {
    
    static let shared = CountdownTimer()
    
    enum State {
        case reset, active, paused, finished
    }
    
    var length: TimeInterval = 300 {
        didSet { if state != .active { reset() } }
    }
    @Published var endDate = Date().addingTimeInterval(300)
    
    @Published private(set) var remaining: TimeInterval = 300
    
    var runTimer: Timer?
    
    @Published private(set) var state = State.reset
    @Published var isScheduled = false {
        didSet { if isScheduled { startScheduledTick() } }
    }
    
    func start() {
        guard runTimer == nil, state != .finished else { return }
        endDate = Date().addingTimeInterval(state == .paused ? remaining : length)
        runTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tick()
        }
        state = .active
    }
    
    func startScheduledTick() {
        guard runTimer == nil, endDate > Date() else { return }
        
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
        remaining = length
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
    
}
