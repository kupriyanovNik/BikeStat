//
//  MainNavigationView.swift
//

import SwiftUI

struct MainNavigationView: View {

    // MARK: - Property Wrappers

    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var rideViewModel: RideViewModel
    @ObservedObject var planningViewModel: PlanningViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var locationManager: LocationManager

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            HomeView(
                homeViewModel: homeViewModel,
                rideViewModel: rideViewModel,
                planningViewModel: planningViewModel,
                coreDataManager: coreDataManager,
                networkManager: networkManager,
                navigationManager: navigationManager
            )
            .navigationDestination(for: NavigationModel.self) { value in
                destinationView(value: value)
            }
        }
    }

    // MARK: - View Builder

    @ViewBuilder func destinationView(value: NavigationModel) -> some View {
        Group {
            if value == .newRide {
                RideView(
                    rideViewModel: rideViewModel,
                    navigationManager: navigationManager,
                    coreDataManager: coreDataManager,
                    networkManager: networkManager,
                    locationManager: locationManager
                )
            } else if value == .settings {
                SettingsView(
                    settingsViewModel: settingsViewModel
                )
            } else if value == .history {
                HistoryView(
                    coreDataManager: coreDataManager
                )
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
        planningViewModel: .init(),
        settingsViewModel :.init(),
        coreDataManager: .init(),
        networkManager: .init(),
        locationManager: .init()
    )
}
