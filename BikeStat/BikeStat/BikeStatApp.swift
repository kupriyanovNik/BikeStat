//
//  BikeStatApp.swift
//

import SwiftUI

@main
struct BikeStatApp: App {

    // MARK: - Property Wrappers

    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var networkManager = NetworkManager()
    @StateObject private var coreDataManager = CoreDataManager()
    @StateObject private var locationManager = LocationManager()

    // MARK: - Body 

    var body: some Scene {
        WindowGroup {
            MainNavigationView(
                navigationManager: navigationManager
            )
        }
    }
}
