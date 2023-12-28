//
//  MainNavigationView.swift
//

import SwiftUI

struct MainNavigationView: View {

    // MARK: - Property Wrappers

    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var locationManager: LocationManager

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            HomeView(
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
        locationManager: .init()
    )
}
