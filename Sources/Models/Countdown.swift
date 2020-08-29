import Foundation

class Countdown: ObservableObject {
    
    let id = UUID()
    @Published var length = Length(timeInterval: 0)
    @Published var date = Date()
    
    let isScheduled: Bool
    
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
