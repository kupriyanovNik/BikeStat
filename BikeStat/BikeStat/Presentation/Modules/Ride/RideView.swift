//
//  RideView.swift
//

import SwiftUI

struct RideView: View {

    // MARK: - Property Wrappers

    @ObservedObject var rideViewModel: RideViewModel
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var locationManager: LocationManager

    // MARK: - Body

    var body: some View {
        RepresentableMapView(
            locationManager: locationManager,
            isCycling: $rideViewModel.isCycling,
            souldCenterMapOnLocation: $rideViewModel.souldCenterMapOnLocation,
            cyclingStartTime: $rideViewModel.cyclingStartTime,
            mapSpanDeltaValue: $rideViewModel.mapSpanDeltaValue
        )
    }
}

// MARK: - Preview 

#Preview {
    RideView(
        rideViewModel: .init(),
        navigationManager: .init(),
        locationManager: .init()
    )
}
