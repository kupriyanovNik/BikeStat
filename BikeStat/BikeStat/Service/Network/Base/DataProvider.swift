//
//  DataProvider.swift
//

import Foundation

final class DataProvider {

    // MARK: - Static Properties

    private static var sessionDispatcher: SessionDispatcher = .init()

    // MARK: - Static Functions

    static func fetchData<R: Request>(_ request: R) async throws -> R.ReturnType {
        guard let urlRequest = request.asURLRequest(Strings.Network.apiUrl) else {
            throw APIError.badRequest
        }
        
        typealias RequestType = R.ReturnType
        let returnType: RequestType = try await sessionDispatcher.dispatch(request: urlRequest)
        return returnType
    }
}
