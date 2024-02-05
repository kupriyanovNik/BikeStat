//
//  RequestImplimentation.swift
//

import Foundation

final class Requests {

    // MARK: - Static Properties

    static let shared = Requests()

    // MARK: - Embedded

    struct GetWatchData: Request {
        typealias ReturnType = NetworkWatchDataModel

        let path: String = "/api/watch"
        let headers: HTTPHeader? = [
            HTTPHeaderField.xAccessTokens.rawValue: NetworkConstants.apiKey
        ]
    }
}
