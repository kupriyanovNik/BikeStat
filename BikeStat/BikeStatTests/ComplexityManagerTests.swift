//
//  ComplexityManagerTests.swift
//

import XCTest
@testable import BikeStat

final class ComplexityManagerTests: XCTestCase {

    // MARK: - Private Properties

    private var manager: ComplexityManager!

    // MARK: - Internal Functions

    override func setUp() {
        super.setUp()

        manager = .shared
    }

    func testEstimatedComplexity() {
        let result1 = manager.getEstimatedComplexity(
            estimatedDistance: 125,
            estimatedTime: 60
        )
        let result2 = manager.getEstimatedComplexity(
            estimatedDistance: 420,
            estimatedTime: 60
        )
        let result3 = manager.getEstimatedComplexity(
            estimatedDistance: 665,
            estimatedTime: 60
        )

        XCTAssertEqual(result1, RideComplexity.easy)
        XCTAssertEqual(result2, RideComplexity.medium)
        XCTAssertEqual(result3, RideComplexity.hard)
    }

    func testRealComplexity() {
        let result1 = manager.getRealComplexity(
            pulse: .init(min: 65, avg: 119, max: 150)
        )
        let result2 = manager.getRealComplexity(
            pulse: .init(min: 23, avg: 143, max: 170)
        )
        let result3 = manager.getRealComplexity(
            pulse: .init(min: 111, avg: 164, max: 169)
        )

        XCTAssertEqual(result1, RideComplexity.easy)
        XCTAssertEqual(result2, RideComplexity.medium)
        XCTAssertEqual(result3, RideComplexity.hard)
    }

    func testGetColorByComplexity() {
        let result1 = manager.getColorByComplexity(
            complexity: RideComplexity.easy.rawValue
        )
        let result2 = manager.getColorByComplexity(
            complexity: RideComplexity.medium.rawValue
        )
        let result3 = manager.getColorByComplexity(
            complexity: RideComplexity.hard.rawValue
        )

        XCTAssertEqual(result1, Pallete.Complexity.easy)
        XCTAssertEqual(result2, Pallete.Complexity.medium)
        XCTAssertEqual(result3, Pallete.Complexity.hard)
    }

    func testGetColorByEstimatedComplexity() {
        let result1 = manager.getColorByEstimatedComplexity(
            complexity: RideComplexity.easy.rawValue
        )
        let result2 = manager.getColorByEstimatedComplexity(
            complexity: RideComplexity.medium.rawValue
        )
        let result3 = manager.getColorByEstimatedComplexity(
            complexity: RideComplexity.hard.rawValue
        )

        XCTAssertEqual(result1, Pallete.EstimatedComplexity.easy)
        XCTAssertEqual(result2, Pallete.EstimatedComplexity.medium)
        XCTAssertEqual(result3, Pallete.EstimatedComplexity.hard)
    }
}
