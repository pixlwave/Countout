import Foundation
import Combine

class Countdown: ObservableObject {
    
    let id = UUID()
    
    @Published var length = Length(timeInterval: 0) {
        didSet { didChangePublisher.send() }
    }
    @Published var date = Date() {
        didSet { didChangePublisher.send() }
    }
    let isScheduled: Bool
    
    @Published var earlyWarningEnabled = false
    @Published var earlyWarningTime: TimeInterval = 120
    @Published var finalWarningEnabled = false
    @Published var finalWarningTime: TimeInterval = 60
    @Published var flashWhenFinished = false
    
    var description: String {
        if isScheduled {
            return date.timeString
        } else {
            return length.timeInterval.lengthString
        }
    }
    
    let didChangePublisher = PassthroughSubject<Void, Never>()
    
    init(_ length: Length) {
        self.length = length
        self.isScheduled = false
    }
    
    init(_ date: Date) {
        self.date = date
        self.isScheduled = true
    }
    
}


extension Countdown: Hashable {
    static func == (lhs: Countdown, rhs: Countdown) -> Bool {
        lhs.id == rhs.id && lhs.length == rhs.length && lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
