//
//  LocationManagerTests.swift
//

import XCTest
@testable import BikeStat

final class LocationManagerTests: XCTestCase {

    // MARK: - Private Properties

    private var manager: LocationManager!

    // MARK: - Internal Functions

    override func setUp() {
        super.setUp()

        manager = LocationManager()
    }

    func testStartRide() {
        manager.startRide()

        delay(3) {
            XCTAssertNotEqual(self.manager.cyclingTotalDistance, 0.0)
        }
    }

    func testEndRide() {
        manager.endRide()

        XCTAssert(manager.cyclingLocations.isEmpty)
        XCTAssert(manager.cyclingSpeeds.isEmpty)
        XCTAssertEqual(self.manager.cyclingTotalDistance, 0.0)
    }
}
