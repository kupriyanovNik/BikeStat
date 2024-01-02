//
//  RideViewModel.swift
//

import Foundation

class RideViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var isCycling: Bool = false 
    @Published var shouldCenterMapOnLocation: Bool = true
    @Published var cyclingStartTime: Date = .now
    @Published var mapSpanDeltaValue: Double = 0.006
}
