import XCTest

class ForecastUITests: XCTestCase {

    var app: XCUIApplication!

    let sectors: [String] = [
        "industrials", "healthcare", "technology", "telecom-media",
        "goods", "energy", "financials", "all"
    ]

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
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeLeft
            app.cells["Sector"].tap()
        }
        var index: Int = 0
        for sectorIcon in app.scrollViews.images.allElementsBoundByIndex {
            sectorIcon.tap()
            XCTAssertTrue(app.navigationBars["\(sectors[index].capitalized)"].exists)
            if index < sectors.count {
                index += 1
            }
        }
    }

    func testTabElements() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            XCTAssertEqual(app.tabBars.buttons.count, 4)
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeLeft
            XCTAssertEqual(app.cells.count, 4)
        }
    }

    func testAddCompany() {
        // Create a new custom company
        if UIDevice.current.userInterfaceIdiom == .pad { return }
        app.scrollViews.images["industrials"].tap()
        app.navigationBars["Industrials"].buttons["add"].tap()
        fillCompany()
        app.buttons["Edit Companies"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There sould be 1 list row - found \(app.tables.cells.count)")
        XCTAssertTrue(app.buttons["Company A"].exists)

        // Modify custom company and save it
        app.buttons["Company A"].tap()
        app.buttons["Modify"].tap()
        modifyAndSave()
        XCTAssertTrue(app.buttons["Company B"].exists)
    }

    // MARK: - Helper functions

    func fillCompany() {
        app.textFields["Company Name"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["A"].tap()

        app.textFields["Stock Symbol"].tap()
        Thread.sleep(forTimeInterval: 0.5) // Make sure the keyboard is showing up
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["A"].tap()

        app.textFields["Twitter @"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["delete"].tap()
        app.keys["more"].tap()
        app.keys["@"].tap()
        app.keys["more"].tap()
        app.keys["c"].tap()
        app.keys["o"].tap()
        app.keys["m"].tap()
        app.keys["a"].tap()

        app.keyboards.buttons["return"].tap()
        app.buttons["Save"].tap()
    }

    func modifyAndSave() {
        app.textFields["Company A"].tap()
        Thread.sleep(forTimeInterval: 0.5) // Make sure the keyboard is showing up
        app.keys["delete"].tap()
        app.keys["B"].tap()
        app.textFields["Stock A"].tap()
        Thread.sleep(forTimeInterval: 0.5) // Make sure the keyboard is showing up
        app.keys["delete"].tap()
        app.keys["B"].tap()
        app.textFields["@coma"].tap()
        Thread.sleep(forTimeInterval: 0.5) // Make sure the keyboard is showing up
        app.keys["delete"].tap()
        app.keys["b"].tap()
        app.buttons["all"].tap()
        app.buttons["Healthcare"].tap()
        app.keyboards.buttons["return"].tap()
        app.buttons["Save"].tap()
    }
}
