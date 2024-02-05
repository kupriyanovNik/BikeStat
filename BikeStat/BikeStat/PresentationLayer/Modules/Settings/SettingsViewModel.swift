//
//  SettingsViewModel.swift
//

import SwiftUI

class SettingsViewModel: ObservableObject {

    // MARK: - Embedded

    private enum LocalConstants {
        static let isMetricUnits = "SETTINGS_DistanceUnits"
        static let userWeight = "SETTINGS_UserWeight"
        static let shouldAutomaticlyEndRide = "SETTINGS_ShouldAutomaticlyEndRide"
    }

    // MARK: - Property Wrappers

    @AppStorage(LocalConstants.isMetricUnits) var isMetricUnits: Bool = true
    @AppStorage(LocalConstants.userWeight) var userWeight: Int = 75
    @AppStorage(LocalConstants.shouldAutomaticlyEndRide) var shouldAutomaticlyEndRide: Bool = false
}
