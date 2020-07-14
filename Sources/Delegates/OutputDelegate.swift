import UIKit
import SwiftUI

class OutputDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene, session.role == .windowExternalDisplay else { return }
        
        window = UIWindow(windowScene: windowScene)
        let hostingController = UIHostingController<CountdownView>(rootView: CountdownView())
        window?.rootViewController = hostingController
        window?.isHidden = false
        
        OutputDisplay.shared.isConnected = true
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        OutputDisplay.shared.isConnected = false
        window = nil
    }
}

class OutputDisplay: ObservableObject {
    static let shared = OutputDisplay()
    @Published var isConnected = false
}
