//
//  ThemeManagerTests.swift
//

import XCTest
@testable import BikeStat

final class ThemeManagerTests: XCTestCase {

    // MARK: - Private Properties

    private var manager: ThemeManager!

    // MARK: - Internal Functions

    override func setUp() {
        super.setUp()

        manager = ThemeManager()
    }

    func testSelectTheme() {
        manager.setThemeIndet(at: 0)
        let selectedThemeIndex = manager.selectedThemeIndex

        XCTAssertEqual(selectedThemeIndex, 0)
        XCTAssertEqual(
            manager.selectedTheme.themeName,
            ThemeDataSource.getTheme(themeIndex: selectedThemeIndex).themeName
        )
    }
}
