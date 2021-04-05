import XCTest

class ForecastUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

    func testScrollViewAndTabs() {
        for sectorIcon in app.scrollViews.buttons.allElementsBoundByIndex {
            sectorIcon.tap()
            XCTAssertEqual(app.tabBars.buttons.count, 4)
            app.buttons["Back"].tap()
        }
    }

    func testAddCompany() {
        // Create a new custom company
        app.buttons["INDUSTRIALS"].tap()
        app.buttons["Add Company"].tap()
        fillCompany()
        app.buttons["ADD"].tap()
        app.buttons["INDUSTRIALS"].tap()
        app.buttons["Edit Companies"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There sould be 1 list row - found \(app.tables.cells.count)")
        XCTAssertTrue(app.buttons["Comp a"].exists)

        // Modify custom company and save it
        app.buttons["Comp a"].tap()
        app.buttons["Modify"].tap()
        modifyAndSave()
        XCTAssertTrue(app.buttons["Comp b"].exists)
    }

    // MARK: - Helper functions

    func fillCompany() {
        app.textFields["Stock Symbol"].tap()
        Thread.sleep(forTimeInterval: 0.5) // Make sure the keyboard is showing up
        app.keys["A"].tap()
        app.keys["a"].tap()
        app.keys["a"].tap()

        app.textFields["Company Name"].tap()
        app.keys["C"].tap()
        app.keys["o"].tap()
        app.keys["m"].tap()
        app.keys["p"].tap()
        app.keys["space"].tap()
        app.keys["a"].tap()

        app.textFields["Twitter @"].tap()
        app.keys["more"].tap()
        app.keys["@"].tap()
        app.keys["more"].tap()
        app.keys["c"].tap()
        app.keys["o"].tap()
        app.keys["m"].tap()
        app.keys["a"].tap()
    }

    func modifyAndSave() {
        app.textFields["Comp a"].tap()
        Thread.sleep(forTimeInterval: 0.5) // Make sure the keyboard is showing up
        app.keys["delete"].tap()
        app.keys["b"].tap()
        app.textFields["Aaa"].tap()
        Thread.sleep(forTimeInterval: 0.5) // Make sure the keyboard is showing up
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["B"].tap()
        app.keys["b"].tap()
        app.keys["b"].tap()
        app.textFields["@coma"].tap()
        Thread.sleep(forTimeInterval: 0.5) // Make sure the keyboard is showing up
        app.keys["delete"].tap()
        app.keys["b"].tap()
        app.buttons["industrials"].tap()
        app.buttons["Healthcare"].tap()
        app.keyboards.buttons["return"].tap()
        app.buttons["Save"].tap()
    }
}
