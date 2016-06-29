import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var countdownVC: CountdownController?
    
    var externalWindow: UIWindow?
    var outputVC: OutputController?
    
    let countdown = CountdownTimer.sharedClient
    var backgroundTime: NSDate?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.idleTimerDisabled = true
        
        countdown.delegate = self
        
        countdownVC = window?.rootViewController as? CountdownController
        
        updateOutput()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateOutput), name: UIScreenDidConnectNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateOutput), name: UIScreenDidDisconnectNotification, object: nil)
        
        return true
    }
    
    func updateOutput() {
        if UIScreen.screens().count > 1 {
            externalWindow = UIWindow(frame: UIScreen.screens()[1].bounds)
            externalWindow?.screen = UIScreen.screens()[1] 
            
            outputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Output") as? OutputController
            
            externalWindow?.rootViewController = outputVC
            externalWindow?.hidden = false
            
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
    
    func applicationDidEnterBackground(application: UIApplication) {
        if countdown.isActive() {
            backgroundTime = NSDate()
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        if let backgroundTime = backgroundTime {
            let timePassed = Int(NSDate().timeIntervalSinceDate(backgroundTime))
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