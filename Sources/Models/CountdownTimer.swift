import Foundation
import Combine

class CountdownTimer: ObservableObject {
    
    static let shared = CountdownTimer()
    
    enum State {
        case reset, active, paused, finished
    }
    
    @Published var current = Countdown(Length(timeInterval: 300)) {
        willSet {
            if state == .active { stop() }
        }
        didSet {
            reset()
            currentSubscription = current.didChangePublisher.sink { value in
                if self.state != .active || self.current.isScheduled { self.reset() }
            }
        }
    }
    
    @Published var queue = [Countdown]()
    
    @Published var endDate = Date().addingTimeInterval(300)
    
    @Published private(set) var remaining: TimeInterval = 300
    
    var runTimer: Timer?
    
    @Published private(set) var state = State.reset
    
    var currentSubscription: AnyCancellable?
    
    private init() {
        currentSubscription = current.didChangePublisher.sink { value in
            if self.state != .active || self.current.isScheduled { self.reset() }
        }
    }
    
    func start() {
        guard runTimer == nil, state != .finished else { return }
        
        if current.isScheduled {
            guard current.date > Date() else { return }
            self.endDate = current.date
        } else {
            guard state != .finished else { return }
            endDate = Date().addingTimeInterval(state == .paused ? remaining : current.length.timeInterval)
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
        
        if current.isScheduled {
            remaining = current.date.timeIntervalSinceNow
        } else {
            remaining = current.length.timeInterval
        }
        
        state = .reset
        
        if current.isScheduled { start() }
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
    
    func next() {
        guard queue.count > 0 else { return }
        current = queue.removeFirst()
    }
    
    func load(_ countdown: Countdown) {
        queue.removeAll { $0 == countdown }
        current = countdown
    }
    
}
