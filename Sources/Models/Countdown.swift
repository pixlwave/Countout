import Foundation
import Observation
import Combine

@Observable class Countdown: Codable, RawRepresentable {
    let id = UUID()
    
    var length = Length(timeInterval: 0) {
        didSet { didChangePublisher.send() }
    }
    var date = Date() {
        didSet { didChangePublisher.send() }
    }
    let isScheduled: Bool
    
    var showsEarlyWarning = false
    var earlyWarningTime: TimeInterval = 120
    var showsFinalWarning = false
    var finalWarningTime: TimeInterval = 60
    var finalWarningFlashes = false
    
    var description: String {
        if isScheduled {
            return date.timeString
        } else {
            return length.timeInterval.lengthString
        }
    }
    
    #warning("Replace with Observation.")
    let didChangePublisher = PassthroughSubject<Void, Never>()
    
    init(_ length: Length) {
        self.isScheduled = false
        self.length = length
    }
    
    init(_ date: Date) {
        self.isScheduled = true
        self.date = date
    }
    
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case length
        case date
        case isScheduled
        case showsEarlyWarning
        case earlyWarningTime
        case showsFinalWarning
        case finalWarningTime
        case finalWarningFlashes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isScheduled = try container.decode(Bool.self, forKey: .isScheduled)
        showsEarlyWarning = try container.decode(Bool.self, forKey: .showsEarlyWarning)
        earlyWarningTime = try container.decode(TimeInterval.self, forKey: .earlyWarningTime)
        showsFinalWarning = try container.decode(Bool.self, forKey: .showsFinalWarning)
        finalWarningTime = try container.decode(TimeInterval.self, forKey: .finalWarningTime)
        finalWarningFlashes = try container.decode(Bool.self, forKey: .finalWarningFlashes)
        length = try container.decode(Length.self, forKey: .length)
        date = try container.decode(Date.self, forKey: .date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(length, forKey: .length)
        try container.encode(date, forKey: .date)
        try container.encode(isScheduled, forKey: .isScheduled)
        try container.encode(showsEarlyWarning, forKey: .showsEarlyWarning)
        try container.encode(earlyWarningTime, forKey: .earlyWarningTime)
        try container.encode(showsFinalWarning, forKey: .showsFinalWarning)
        try container.encode(finalWarningTime, forKey: .finalWarningTime)
        try container.encode(finalWarningFlashes, forKey: .finalWarningFlashes)
    }
    
    
    // MARK: RawRepresentable
    required init?(rawValue: String) {
        guard
            let data = rawValue.data(using: .utf8),
            let decoded = try? JSONDecoder().decode(Countdown.self, from: data)
        else { return nil }
        
        self.isScheduled = decoded.isScheduled
        self.showsEarlyWarning = decoded.showsEarlyWarning
        self.earlyWarningTime = decoded.earlyWarningTime
        self.showsFinalWarning = decoded.showsFinalWarning
        self.finalWarningTime = decoded.finalWarningTime
        self.finalWarningFlashes = decoded.finalWarningFlashes
        self.length = decoded.length
        self.date = decoded.date
    }
    
    var rawValue: String {
        guard
            let data = try? JSONEncoder().encode(self),
            let string = String(data: data, encoding: .utf8)
        else { return "" }
        
        return string
    }
}


// MARK: Hashable
extension Countdown: Hashable {
    static func == (lhs: Countdown, rhs: Countdown) -> Bool {
        lhs.id == rhs.id && lhs.length == rhs.length && lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
