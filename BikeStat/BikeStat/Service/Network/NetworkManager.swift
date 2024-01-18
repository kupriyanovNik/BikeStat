//
//  NetworkManager.swift
//

import Foundation

@MainActor class NetworkManager: ObservableObject {

    // MARK: - Property Wrappers

    @Published var watchData: NetworkWatchDataModel?

    // MARK: - Private Properties

    private let decoder = JSONDecoder()
    private let networkConstants = Strings.Network.self

    // MARK: - Internal Functions 

    func getWatchData() {
        Task {
            let url = URL(string: networkConstants.apiUrl)!
//            let url = URL(string: "MOCK URL")!
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = networkConstants.headerFields

            print("[\(request.httpMethod ?? "")] \(request.url?.absoluteString ?? "")")

            do {
                watchData = try await loadNetworkWatchData(request: request)
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Private Functions

    private func loadNetworkWatchData(request: URLRequest) async throws -> NetworkWatchDataModel? {
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(NetworkWatchDataModel.self, from: data)
    }
}
