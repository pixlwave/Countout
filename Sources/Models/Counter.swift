import SwiftUI
import Observation
import Combine

@Observable class Counter {
    static let shared = Counter()
    
    enum State {
        case reset, active, paused, finished
    }
    
    #warning("Remove public setter (used in state restoration).")
    var current = Countdown(Length(timeInterval: 300)) {
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
    
#warning("Remove public setter (used in state restoration).")
    var queue = [Countdown]()
    
    private var endDate = Date().addingTimeInterval(300)
    
    private(set) var remaining: TimeInterval = 300
    
    private var runTimer: Timer?
    
    private(set) var state = State.reset
    
    private var currentSubscription: AnyCancellable?
    
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

// MARK: - Mock States

extension Counter {
    func mockDefaultState() {
        current = Countdown(Length(timeInterval: 300))
        queue = []
        remaining = 300
    }
    
    func mockQueueState() {
        current = Countdown(.today(atHour: 9, minute: 45))
        queue = [
            Countdown(.today(atHour: 10, minute: 00)),
            Countdown(.today(atHour: 10, minute: 45)),
            Countdown(.today(atHour: 11, minute: 15))
        ]
        if UIDevice.current.userInterfaceIdiom == .pad {
            queue.append(contentsOf: [Countdown(.today(atHour: 11, minute: 35)),
                                      Countdown(.today(atHour: 12, minute: 00))])
        }
        remaining = 269
        state = .active
    }
    
    func mockOutputState() {
        current = Countdown(Length(timeInterval: 480))
        queue = []
        remaining = 455
        state = .active
    }
}
