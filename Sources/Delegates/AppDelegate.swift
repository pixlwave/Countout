import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        coder.encode(Counter.shared.current.rawValue, forKey: "currentCountdown")
        coder.encode(Counter.shared.queue.rawValue, forKey: "countdownQueue")
        
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        if let rawValue = coder.decodeObject(forKey: "currentCountdown") as? String,
           let current = Countdown(rawValue: rawValue) {
            Counter.shared.current = current
        }
        
        if let rawValue = coder.decodeObject(forKey: "countdownQueue") as? String,
           let queue = Array<Countdown>(rawValue: rawValue) {
            Counter.shared.queue = queue
        }
        
        return true
    }
}
