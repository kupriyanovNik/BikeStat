//
//  NavigationManager.swift
//

import Foundation

final class NavigationManager: ObservableObject {
    
    // MARK: - Property Wrappers

    @Published var path: [NavigationModel] = []

    // MARK: - Internal Functions 

    func showRideView() {
        path.append(.newRide)
    }

    func showHistoryView() {
        path.append(.history)
    }

    func showStatisticsView() {
        path.append(.statistics)
    }

    func showSettingsView() {
        path.append(.settings)
    }
}
