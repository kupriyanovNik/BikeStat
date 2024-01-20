//
//  PlanningViewModel.swift
//

import Foundation

class PlanningViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var rideTitle: String = ""
    @Published var rideDate: Date = .now
    @Published var estimatedTime: Int = 90
    @Published var estimatedDistance: Int = 1000 // in meters

}
