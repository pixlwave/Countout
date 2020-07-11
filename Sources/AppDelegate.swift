import UIKit
import SwiftUI

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var countdownVC: CountdownController?
    
    var externalWindow: UIWindow?
    var outputVC: UIHostingController<CountdownView>?
    
    let countdown = CountdownTimer.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true
        
        countdownVC = window?.rootViewController as? CountdownController
        
        updateOutput()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOutput), name: UIScreen.didConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateOutput), name: UIScreen.didDisconnectNotification, object: nil)
        
        return true
    }
    
    @objc func updateOutput() {
        if UIScreen.screens.count > 1 {
            externalWindow = UIWindow(frame: UIScreen.screens[1].bounds)
            externalWindow?.screen = UIScreen.screens[1]
            
            outputVC = UIHostingController<CountdownView>(rootView: CountdownView())
            
            externalWindow?.rootViewController = outputVC
            externalWindow?.isHidden = false
            
            // countdownVC?.outputExists = true
        } else {
            countdownVC?.outputVC = nil
            outputVC = nil
            externalWindow = nil
            
            // countdownVC?.outputExists = false
        }
    }
    
}
