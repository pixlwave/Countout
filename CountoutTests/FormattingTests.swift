import XCTest
@testable import Countout

final class FormattingTests: XCTestCase {
    func testRemainingFormatting() {
        XCTAssertEqual(TimeInterval(3600).remainingString, "1:00:00", "Hours should be shown with no padding")
        XCTAssertEqual(TimeInterval(3599).remainingString, "59:59")
        XCTAssertEqual(TimeInterval(600).remainingString, "10:00")
        XCTAssertEqual(TimeInterval(300).remainingString, "5:00")
        XCTAssertEqual(TimeInterval(60).remainingString, "1:00")
        XCTAssertEqual(TimeInterval(59.1).remainingString, "1:00", "Fractional seconds should round up and adding to the next unit if necessary.")
        XCTAssertEqual(TimeInterval(59).remainingString, "0:59", "Minutes should always be shown, even when there's less than a minute remaining.")
        XCTAssertEqual(TimeInterval(0.1).remainingString, "0:01", "Fractional seconds should be rounded up, no matter how small.")
        XCTAssertEqual(TimeInterval(0).remainingString, "0:00")
        XCTAssertEqual(TimeInterval(-1).remainingString, "0:00", "Negative intervals shouldn't be shown.")
        XCTAssertEqual(TimeInterval(-60).remainingString, "0:00")
        XCTAssertEqual(TimeInterval(-3600).remainingString, "0:00")
    }
    
    func testLengthFormatting() {
        XCTAssertEqual(TimeInterval(7201).lengthString, "120 minutes, 1 second", "Hours should not be shown.")
        XCTAssertEqual(TimeInterval(3600).lengthString, "60 minutes", "Hours should not be shown.")
        XCTAssertEqual(TimeInterval(120).lengthString, "2 minutes", "When seconds is 0, it should be hidden.")
        XCTAssertEqual(TimeInterval(90).lengthString, "1 minute, 30 seconds")
        XCTAssertEqual(TimeInterval(61).lengthString, "1 minute, 1 second")
        XCTAssertEqual(TimeInterval(60).lengthString, "1 minute", "When seconds is 0, it should be hidden.")
        XCTAssertEqual(TimeInterval(59).lengthString, "59 seconds")
        XCTAssertEqual(TimeInterval(1).lengthString, "1 second")
        XCTAssertEqual(TimeInterval(0.1).lengthString, "0 seconds", "Fractional settings should be rounded naturally.")
        XCTAssertEqual(TimeInterval(0).lengthString, "0 seconds")
    }
    
    func testDateFormatting() {
        let now = Date.now
        let components = Calendar.current.dateComponents([.hour, .minute], from: now)
        let symbol = (components.hour! / 12) > 0 ? Calendar.current.pmSymbol : Calendar.current.amSymbol
        XCTAssertEqual(now.timeString, "Today, \(components.hour! % 12):\(components.minute!) \(symbol)", "Hours should not be shown.")
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)!
        XCTAssertEqual(tomorrow.timeString, "Tomorrow, \(components.hour! % 12):\(components.minute!) \(symbol)", "Hours should not be shown.")
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        XCTAssertEqual(yesterday.timeString, "Yesterday, \(components.hour! % 12):\(components.minute!) \(symbol)", "Hours should not be shown.")
    }
}
