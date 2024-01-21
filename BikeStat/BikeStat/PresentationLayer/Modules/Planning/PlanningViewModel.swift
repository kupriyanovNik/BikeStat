//
//  PlanningViewModel.swift
//

import Foundation

class PlanningViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var rideTitle: String = ""
    @Published var rideDate: Date = .now
    @Published var estimatedTime: Int = 30 // in minutes
    @Published var estimatedDistance: Int = 1000 // in meters

    // MARK: - Internal Functions

    func reset() {
        rideTitle = ""
        rideDate = .now
        estimatedTime = 30
        estimatedDistance = 1000
    }

}
