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

    @ViewBuilder func toggleRideButton() -> some View {
        Button {
            if rideViewModel.isRideStarted {
                persistRide()
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

    private func persistRide() {
        let cyclingSpeeds = locationManager.cyclingSpeeds.map { Int($0 ?? 0) }
        let avgSpeed = cyclingSpeeds.reduce(0, +) / cyclingSpeeds.count
        var maxSpeed = 0
        for item in cyclingSpeeds {
            if item > maxSpeed {
                maxSpeed = item
            }
        }

        networkManager.getWatchData()

        delay(0.5) {
            let pulse = networkManager.watchData?.data.pulse
            
            coreDataManager.addRide(
                time: Int(rideViewModel.totalAccumulatedTime),
                date: rideViewModel.cyclingStartTime,
                distance: Int(locationManager.cyclingTotalDistance),
                estimatedComplexity: "хз не играл",
                realComplexity: "вообще хз не играл",
                pulse: .init(
                    min: pulse?.min ?? 0,
                    avg: pulse?.avg ?? 0,
                    max: pulse?.max ?? 0
                ),
                speed: .init(
                    //TODO: - вылет если cyclingSpeeds.count = 0
                    avg: avgSpeed,
                    max: maxSpeed
                )
            )
        }
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
