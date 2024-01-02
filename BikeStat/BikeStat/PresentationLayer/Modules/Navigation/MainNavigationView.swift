//
//  MainNavigationView.swift
//

import SwiftUI

struct MainNavigationView: View {

    // MARK: - Property Wrappers

    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var rideViewModel: RideViewModel
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var locationManager: LocationManager

    // MARK: - Body

    var body: some View {
        NavigationView {
            HomeView(
                homeViewModel: homeViewModel,
                coreDataManager: coreDataManager,
                networkManager: networkManager,
                navigationManager: navigationManager
            )
            .overlay {
                NavigationLink(
                    isActive: $navigationManager.shouldShowRideScreen
                ) {
                    RideView(
                        rideViewModel: rideViewModel,
                        navigationManager: navigationManager,
                        coreDataManager: coreDataManager,
                        networkManager: networkManager,
                        locationManager: locationManager
                    )
                } label: { }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MainNavigationView(
        navigationManager: .init(),
        homeViewModel: .init(),
        rideViewModel: .init(),
        coreDataManager: .init(),
        networkManager: .init(),
        locationManager: .init()
    )
}
