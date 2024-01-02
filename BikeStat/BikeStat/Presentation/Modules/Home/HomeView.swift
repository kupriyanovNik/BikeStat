//
//  HomeView.swift
//

import SwiftUI

struct HomeView: View {

    // MARK: - Property Wrappers

    @ObservedObject var rideViewModel: RideViewModel
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var locationManager: LocationManager

    // MARK: - Body

    var body: some View {
        VStack {
            NavigationLink {
                RideView(
                    rideViewModel: rideViewModel,
                    navigationManager: navigationManager,
                    coreDataManager: coreDataManager,
                    networkManager: networkManager,
                    locationManager: locationManager
                )
                .ignoresSafeArea(edges: .bottom)
            } label: {
                Text("New Ride")
            }
        }
        .padding()
    }
}

// MARK: - Preview 

#Preview {
    HomeView(
        rideViewModel: .init(),
        coreDataManager: .init(),
        networkManager: .init(),
        navigationManager: .init(),
        locationManager: .init()
    )
}
