//
//  SettingsViewModel.swift
//
import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @AppStorage("SETTINGS_DistanceUnits") var isMetricUnits: Bool = true
    @AppStorage("SETTINGS_UserWeight") var userWeight: Int = 75
}
