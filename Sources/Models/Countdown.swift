import Foundation

class Countdown: ObservableObject {
    
    enum Value: Equatable {
        case length(TimeInterval)
        case date(Date)
    }
    
    let id = UUID()
    @Published var value: Value
    
    init(_ value: Value) {
        self.value = value
    }
}


extension Countdown: Hashable {
    static func == (lhs: Countdown, rhs: Countdown) -> Bool {
        lhs.id == rhs.id && lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
