import Foundation

class CountdownTimer: ObservableObject {
    
    static let shared = CountdownTimer()
    
    enum State {
        case reset, active, paused, finished
    }
    
    @Published var current = Countdown(.length(300)) {
        didSet { if state != .active { reset() } }
    }
    
    @Published var queue = [Countdown]()
    
    @Published var endDate = Date().addingTimeInterval(300)
    
    @Published private(set) var remaining: TimeInterval = 300
    
    var runTimer: Timer?
    
    @Published private(set) var state = State.reset
    
    func start() {
        guard runTimer == nil, state != .finished else { return }
        
        switch current.value {
        case .length(let length):
            guard state != .finished else { break }
            endDate = Date().addingTimeInterval(state == .paused ? remaining : length)
        case .date(let date):
            guard date > Date() else { break }
            self.endDate = date
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
        
        switch current.value {
        case .length(let length):
            remaining = length
        case .date(let date):
            remaining = date.timeIntervalSinceNow
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
    
    func nextCountdown() {
        guard queue.count > 0 else { return }
        current = queue.removeFirst()
    }
    
}
