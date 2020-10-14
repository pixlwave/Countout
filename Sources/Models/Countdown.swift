import Foundation
import Combine

class Countdown: Codable, ObservableObject, RawRepresentable {
    
    let id = UUID()
    
    @Published var length = Length(timeInterval: 0) {
        didSet { didChangePublisher.send() }
    }
    @Published var date = Date() {
        didSet { didChangePublisher.send() }
    }
    let isScheduled: Bool
    
    @Published var showsEarlyWarning = false
    @Published var earlyWarningTime: TimeInterval = 120
    @Published var showsFinalWarning = false
    @Published var finalWarningTime: TimeInterval = 60
    @Published var finalWarningFlashes = false
    
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
        length = try container.decode(Length.self, forKey: .length)
        date = try container.decode(Date.self, forKey: .date)
        isScheduled = try container.decode(Bool.self, forKey: .isScheduled)
        showsEarlyWarning = try container.decode(Bool.self, forKey: .showsEarlyWarning)
        earlyWarningTime = try container.decode(TimeInterval.self, forKey: .earlyWarningTime)
        showsFinalWarning = try container.decode(Bool.self, forKey: .showsFinalWarning)
        finalWarningTime = try container.decode(TimeInterval.self, forKey: .finalWarningTime)
        finalWarningFlashes = try container.decode(Bool.self, forKey: .finalWarningFlashes)
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
        
        self.length = decoded.length
        self.date = decoded.date
        self.isScheduled = decoded.isScheduled
        self.showsEarlyWarning = decoded.showsEarlyWarning
        self.earlyWarningTime = decoded.earlyWarningTime
        self.showsFinalWarning = decoded.showsFinalWarning
        self.finalWarningTime = decoded.finalWarningTime
        self.finalWarningFlashes = decoded.finalWarningFlashes
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
