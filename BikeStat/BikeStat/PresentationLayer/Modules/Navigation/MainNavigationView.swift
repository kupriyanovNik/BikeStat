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
                planningViewModel: planningViewModel,
                coreDataManager: coreDataManager,
                networkManager: networkManager,
                navigationManager: navigationManager
            )
            .navigationDestination(for: String.self) { value in
                destinationView(value: value)
            }
        }
    }

    // MARK: - View Builder

    @ViewBuilder func destinationView(value: String) -> some View {
        Group {
            if value == Strings.Navigation.newRide {
                RideView(
                    rideViewModel: rideViewModel,
                    navigationManager: navigationManager,
                    coreDataManager: coreDataManager,
                    networkManager: networkManager,
                    locationManager: locationManager
                )
            } else if value == Strings.Navigation.settings {
                SettingsView(
                    settingsViewModel: settingsViewModel
                )
            } else if value == Strings.Navigation.history {
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
