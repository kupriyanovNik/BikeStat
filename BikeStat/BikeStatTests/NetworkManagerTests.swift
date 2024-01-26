//
//  NetworkManagerTests.swift
//

import XCTest
@testable import BikeStat

final class NetworkManagerTests: XCTestCase {

    // MARK: - Private Properties

    private var manager: NetworkManager!

    // MARK: - Internal Functions

    override func setUp() {
        super.setUp()

        Task {
            manager = await NetworkManager()
        }
    }

    func testWatchDataRequest() async throws {
        let result = try await DataProvider.fetchData(Requests.GetWatchData())
        XCTAssertNotNil(result)
    }
}
