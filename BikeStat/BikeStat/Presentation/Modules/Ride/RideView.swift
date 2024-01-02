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
            souldCenterMapOnLocation: $rideViewModel.shouldCenterMapOnLocation,
            cyclingStartTime: $rideViewModel.cyclingStartTime,
            mapSpanDeltaValue: $rideViewModel.mapSpanDeltaValue
        )
        .overlay(alignment: .center) {
            if rideViewModel.shouldCenterMapOnLocation {
                mapSpanControls()
            }
        }
        .overlay(alignment: .bottom) {
            toggleRideButton()
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func toggleRideButton() -> some View {
        Button {
            // TODO: - start/end ride
        } label: {
            HStack {
                if rideViewModel.isCycling {
                    Text("6 seconds")
                        .monospaced()
                        .contentTransition(.numericText())
                }

                Text("Начать")
                    .font(.headline)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
        }
        .buttonStyle(MainButtonStyle())
        .hTrailing()
        .padding(.trailing)
    }

    @ViewBuilder func mapSpanControls() -> some View {
        VStack {
            Button {
                withAnimation {
                    rideViewModel.mapSpanDeltaValue = max(
                        rideViewModel.mapSpanDeltaValue - 0.001,
                        0.001
                    )
                }
            } label: {
                Image(systemName: "plus")
                    .bold()
                    .foregroundStyle(.black)
                    .padding()
                    .frame(width: 50, height: 50)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
            .buttonStyle(MainButtonStyle())

            Button {
                withAnimation {
                    rideViewModel.mapSpanDeltaValue += 0.001
                }
            } label: {
                Image(systemName: "minus")
                    .bold()
                    .foregroundStyle(.black)
                    .padding()
                    .frame(width: 50, height: 50)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
            .buttonStyle(MainButtonStyle())
        }
        .hLeading()
        .padding(.leading)
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
