//
//  BikeStatApp.swift
//

import SwiftUI

@main
struct BikeStatApp: App {

    // MARK: - Property Wrappers

    @StateObject private var rideViewModel = RideViewModel()

    @StateObject private var coreDataManager = CoreDataManager()
    @StateObject private var networkManager = NetworkManager()
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var locationManager = LocationManager()

    // MARK: - Body 

    var body: some Scene {
        WindowGroup {
            MainNavigationView(
                navigationManager: navigationManager,
                rideViewModel: rideViewModel,
                coreDataManager: coreDataManager,
                networkManager: networkManager,
                locationManager: locationManager
            )
        }
    }
}
