import XCTest

class pokedexUITests: XCTestCase {

    lazy var app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testCellsExistence_WhenLaunchApp() throws {
        app.launch()

        _ = app.collectionViews.cells.element(boundBy: 0).waitForExistence(timeout: 20)

        XCTAssert(app.collectionViews.cells.element(boundBy: 2).exists)
        takeScreenshot(name: "Pokedex")
    }

    func takeScreenshot(name: String) {
        let fullScreenshot = XCUIScreen.main.screenshot()

        let attachment = XCTAttachment(uniformTypeIdentifier: "public.png", name: "\(UIDevice.current.model)-\(name).png",
                                       payload: fullScreenshot.pngRepresentation,
                                       userInfo: nil)

        attachment.lifetime = .keepAlways

        add(attachment)
    }
}
