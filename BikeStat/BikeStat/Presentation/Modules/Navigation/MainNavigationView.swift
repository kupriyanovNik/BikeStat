//
//  MainNavigationView.swift
//

import SwiftUI

struct MainNavigationView: View {

    // MARK: - Property Wrappers

    @ObservedObject var rideViewModel: RideViewModel
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var locationManager: LocationManager

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            HomeView(
                rideViewModel: rideViewModel,
                navigationManager: navigationManager,
                locationManager: locationManager
            )
        }
    }
}

// MARK: - Preview 

#Preview {
    MainNavigationView(
        rideViewModel: .init(),
        navigationManager: .init(),
        locationManager: .init()
    )
}
