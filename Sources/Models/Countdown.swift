import Foundation

class Countdown: ObservableObject {
    
    enum Value: Hashable {
        case timer(TimeInterval)
        case schedule(Date)
    }
    
    @Published var value: Value
    
    init(_ value: Value) {
        self.value = value
    }
}


extension Countdown: Hashable {
    static func == (lhs: Countdown, rhs: Countdown) -> Bool {
        lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
