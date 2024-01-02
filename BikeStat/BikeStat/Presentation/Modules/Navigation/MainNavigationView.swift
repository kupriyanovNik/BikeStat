//
//  MainNavigationView.swift
//

import SwiftUI

struct MainNavigationView: View {

    // MARK: - Property Wrappers

    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var rideViewModel: RideViewModel
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var locationManager: LocationManager

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            HomeView(
                rideViewModel: rideViewModel,
                coreDataManager: coreDataManager,
                networkManager: networkManager,
                navigationManager: navigationManager,
                locationManager: locationManager
            )
        }
    }
}

// MARK: - Preview 

#Preview {
    MainNavigationView(
        navigationManager: .init(),
        rideViewModel: .init(),
        coreDataManager: .init(),
        networkManager: .init(),
        locationManager: .init()
    )
}
