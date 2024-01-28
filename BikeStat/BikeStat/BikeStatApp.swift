//
//  BikeStatApp.swift
//

import SwiftUI

@main
struct BikeStatApp: App {

    // MARK: - Property Wrappers

    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var rideViewModel = RideViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var planningViewModel = PlanningViewModel()
    @StateObject private var coreDataManager = CoreDataManager()
    @StateObject private var networkManager = NetworkManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var themeManager = ThemeManager()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            MainNavigationView(
                navigationManager: navigationManager,
                homeViewModel: homeViewModel,
                rideViewModel: rideViewModel,
                planningViewModel: planningViewModel,
                settingsViewModel: settingsViewModel,
                coreDataManager: coreDataManager,
                networkManager: networkManager,
                locationManager: locationManager,
                themeManager: themeManager
            )
        }
    }
}
