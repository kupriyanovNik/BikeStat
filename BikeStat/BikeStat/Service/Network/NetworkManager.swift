//
//  NetworkManager.swift
//

import Foundation

@MainActor
class NetworkManager: ObservableObject {

    // MARK: - Property Wrappers

    @Published var watchData: NetworkWatchDataModel?

    // MARK: - Internal Functions

    func getWatchData() {
        Task {
            do {
                watchData = try await DataProvider.fetchData(Requests.GetWatchData())
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
}
