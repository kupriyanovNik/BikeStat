//
//  RideView.swift
//

import SwiftUI
import MapKit

struct RideView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var rideViewModel: RideViewModel
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var locationManager: LocationManager

    @State private var shouldCenterMapOnLocation: Bool = true
    @State private var mapSpanDeltaValue: Double = 0.006

    // MARK: - Private Properties

    private var toggleRideButtonText: String {
        rideViewModel.isRideStarted ? "Закончить" : "Начать"
    }

    private var cyclingTotalDistanceText: String {
        rideViewModel.isRideStarted ?
            ": \(round(locationManager.cyclingTotalDistance / 10) / 100)км" :
            ""
    }

    // MARK: - Body

    var body: some View {
        VStack {
            RepresentableMapView(
                locationManager: locationManager,
                isCycling: $rideViewModel.isRideStarted,
                souldCenterMapOnLocation: $shouldCenterMapOnLocation,
                cyclingStartTime: $rideViewModel.cyclingStartTime,
                mapSpanDeltaValue: $mapSpanDeltaValue
            )
            .ignoresSafeArea(edges: .bottom)
        }
        .overlay(alignment: .center) {
            if shouldCenterMapOnLocation {
                mapSpanControls()
            }
        }
        .overlay(alignment: .bottom) {
            toggleRideButton()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }

    // MARK: - ViewBuilders

    @ViewBuilder func headerView() -> some View {
        let isRideStarted = rideViewModel.isRideStarted

        HStack {
            VStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                .opacity(isRideStarted ? 0 : 1)
            }

            Text("Поездка" + cyclingTotalDistanceText)
                .font(.title)
                .bold()

            Spacer()

            Button {
                withAnimation {
                    shouldCenterMapOnLocation.toggle()
                }
            } label: {
                Image(systemName: shouldCenterMapOnLocation ? "lock" : "lock.open")
                    .foregroundColor(.black)
                    .font(.title2)
            }
            .buttonStyle(MainButtonStyle())
        }
        .foregroundStyle(.black)
        .padding(.horizontal)
        .animation(.default, value: isRideStarted)
    }

    @ViewBuilder func toggleRideButton() -> some View {
        Button {
            if rideViewModel.isRideStarted {
                rideViewModel.endRide()
                locationManager.endRide()
            } else {
                rideViewModel.startRide()
                locationManager.startRide()
            }
        } label: {
            HStack {
                if rideViewModel.isRideStarted {
                    Text(formatTimeString(accumulatedTime: rideViewModel.totalAccumulatedTime))
                        .monospaced()
                        .contentTransition(.numericText())
                }

                Text(toggleRideButtonText)
                    .font(.headline)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
        }
        .buttonStyle(MainButtonStyle())
        .animation(.default, value: rideViewModel.totalAccumulatedTime)
        .hTrailing()
        .padding(.trailing)
    }

    @ViewBuilder func mapSpanControls() -> some View {
        VStack {
            Button {
                withAnimation {
                    mapSpanDeltaValue = max(mapSpanDeltaValue - 0.001, 0.001)
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
                    mapSpanDeltaValue += 0.001
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

    // MARK: - Private Funcations

    private func formatTimeString(accumulatedTime: TimeInterval) -> String {
        let hours = Int(accumulatedTime) / 3600
        let minutes = Int(accumulatedTime) / 60 % 60
        let seconds = Int(accumulatedTime) % 60

        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

// MARK: - Preview

#Preview {
    RideView(
        rideViewModel: .init(),
        navigationManager: .init(),
        coreDataManager: .init(),
        networkManager: .init(),
        locationManager: .init()
    )
}
