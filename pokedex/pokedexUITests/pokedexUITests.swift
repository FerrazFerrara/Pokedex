import XCTest

class pokedexUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testCellsExistence_WhenLaunchApp() throws {
        let app = XCUIApplication()
        app.launch()

        _ = app.collectionViews.cells.element(boundBy: 0).waitForExistence(timeout: 20)

        XCTAssert(app.collectionViews.cells.element(boundBy: 2).exists)
    }
}
