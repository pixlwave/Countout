import XCTest

final class AppStore: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testDefaultState() {
        let app = launch(state: .default)
        takeScreenshot(named: "Main")
        
        app.buttons["Edit Timer Button"].tap()
        app.textFields["Minutes Text Field"].tap()
        app.typeText("20")
        takeScreenshot(named: "Edit")
    }
    
    func testTimerQueue() {
        launch(state: .queue)
        takeScreenshot(named: "Queue")
    }
    
    func testOutput() {
        launch(state: .output)
        takeScreenshot(named: "Output")
    }
    
    func testAppearance() {
        let app = launch(state: .appearance)
        app.buttons["Format"].tap()
        app.navigationBars["Appearance"].waitForExistence(timeout: 1)
        takeScreenshot(named: "Appearance")
    }
    
    // MARK: -
    
    @discardableResult
    private func launch(state: AppState) -> XCUIApplication {
        print("Launching \(UIDevice.current.name), \(state.rawValue)")
        let app = XCUIApplication()
        app.launchArguments.append("-Snapshot")
        app.launchArguments.append(state.rawValue)
        app.launch()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeLeft
        }
        
        return app
    }
    
    private func takeScreenshot(named name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let data = screenshot.pngRepresentation
        try! data.write(to: URL(filePath: "/Users/Shared/Pictures/Countout/\(UIDevice.current.name)-\(name).png"))
    }
}
