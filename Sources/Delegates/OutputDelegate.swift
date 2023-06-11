import UIKit
import SwiftUI

class OutputDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene, session.role == .windowExternalDisplayNonInteractive else { return }
        
        let rootView = CountdownView()
            .environmentObject(Counter.shared)
            .environmentObject(Appearance.shared)
        
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .black
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = hostingController
        window.isHidden = false
        
        UIApplication.shared.isIdleTimerDisabled = true
        OutputDisplay.shared.isConnected = true
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        UIApplication.shared.isIdleTimerDisabled = false
        OutputDisplay.shared.isConnected = false
        window = nil
    }
}

class OutputDisplay: ObservableObject {
    static let shared = OutputDisplay()
    @Published var isConnected = false
}
