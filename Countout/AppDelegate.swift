import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var countdownVC: CountdownController?
    
    var externalWindow: UIWindow?
    var outputVC: OutputController?
    
    let countdown = CountdownTimer.sharedClient
    var backgroundTime: Date?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
        
        countdown.delegate = self
        
        countdownVC = window?.rootViewController as? CountdownController
        
        updateOutput()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOutput), name: NSNotification.Name.UIScreenDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateOutput), name: NSNotification.Name.UIScreenDidDisconnect, object: nil)
        
        return true
    }
    
    func updateOutput() {
        if UIScreen.screens.count > 1 {
            externalWindow = UIWindow(frame: UIScreen.screens[1].bounds)
            externalWindow?.screen = UIScreen.screens[1] 
            
            outputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Output") as? OutputController
            
            externalWindow?.rootViewController = outputVC
            externalWindow?.isHidden = false
            
            countdownVC?.outputVC = outputVC
            countdownVC?.outputExists = true
            
            countdownHasChanged()
        } else {
            countdownVC?.outputVC = nil
            outputVC = nil
            externalWindow = nil
            
            countdownVC?.outputExists = false
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if countdown.isActive() {
            backgroundTime = Date()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let backgroundTime = backgroundTime {
            let timePassed = Int(Date().timeIntervalSince(backgroundTime))
            countdown.addToRemaining(-timePassed)
            
            self.backgroundTime = nil
        }
    }

}

// MARK: CountdownTimerDelegate
extension AppDelegate: CountdownTimerDelegate {
    func countdownHasChanged() {
        let remainingString = String(countdown.remaining / 60) + ":" + String(format: "%02d", (countdown.remaining % 60))
        outputVC?.countdownView?.text = remainingString
        countdownVC?.countdownView?.text = remainingString
    }
    
    func countdownHasFinished() {
        countdownVC?.countdownHasFinished()
    }
}
