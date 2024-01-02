//
//  HomeView.swift
//

import SwiftUI

struct HomeView: View {

    // MARK: - Property Wrappers

    @ObservedObject var rideViewModel: RideViewModel
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var locationManager: LocationManager

    // MARK: - Body

    var body: some View {
        VStack {
            NavigationLink {
                RideView(
                    rideViewModel: rideViewModel,
                    navigationManager: navigationManager,
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
        navigationManager: .init(),
        locationManager: .init()
    )
}
