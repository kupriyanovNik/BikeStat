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
        rideViewModel.isRideStarted ? "Финиш" : "Старт"
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
            .ignoresSafeArea()
        }
        .safeAreaInset(edge: .top, content: headerView)
        .overlay(alignment: .center) {
            if shouldCenterMapOnLocation {
                mapSpanControls()
            }
        }
        .overlay(alignment: .bottom, content: toggleRideButton)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }

    // MARK: - ViewBuilders 

    @ViewBuilder func headerView() -> some View {
        HStack {
            Spacer()

            Text("Новая поездка")
                .font(.largeTitle)
                .bold()

            Spacer()
        }
        .overlay {
            VStack {
                if !rideViewModel.isRideStarted {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: Images.back)
                            .font(.title2)
                            .bold()
                    }
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
            }
            .hLeading()
        }
        .foregroundStyle(.black)
        .padding([.horizontal, .top])
        .offset(y: -16)
        .animation(.linear, value: rideViewModel.isRideStarted)
    }

    @ViewBuilder func toggleRideButton() -> some View {
        Button {
            toggleRideButtonAction()
        } label: {
            VStack {
                Text(toggleRideButtonText)

                Text(
                    formatTimeString(
                        accumulatedTime: rideViewModel.totalAccumulatedTime
                    )
                )
            }
            .font(.title)
            .bold()
            .foregroundStyle(.white)
            .padding(.vertical)
            .padding(.horizontal, 36)
            .background {
                Color.init(hex: 0xB180C8, alpha: 0.54)
                    .cornerRadius(20)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .inset(by: -0.5)
                    .stroke(.black, lineWidth: 1)
            }
        }
        .buttonStyle(
            MainButtonStyle(
                pressedScale: rideViewModel.isRideStarted ? 0.9 : 1.1
            )
        )
    }

    @ViewBuilder func mapSpanControls() -> some View {
        VStack {
            mapSpanControlButton(imageName: "plus") {
                withAnimation {
                    mapSpanDeltaValue = max(mapSpanDeltaValue - 0.003, 0.003)
                }
            }

            mapSpanControlButton(imageName: "minus") {
                withAnimation {
                    mapSpanDeltaValue += 0.003
                }
            }
        }
        .hTrailing()
        .padding(.trailing)
    }

    @ViewBuilder func mapSpanControlButton(
        imageName: String,
        action: @escaping () -> ()
    ) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: imageName)
                .bold()
                .foregroundStyle(.white)
                .padding()
                .frame(width: 40, height: 40)
                .background(
                    Color.init(hex: 0xB180C8)
                )
                .cornerRadius(5)
        }
        .buttonStyle(MainButtonStyle())
    }

    // MARK: - Private Funcations

    private func toggleRideButtonAction() {
        if rideViewModel.isRideStarted {
            persistRide()
            rideViewModel.endRide()
            locationManager.endRide()
        } else {
            rideViewModel.startRide()
            locationManager.startRide()
        }
    }

    private func formatTimeString(accumulatedTime: TimeInterval) -> String {
        let hours = Int(accumulatedTime) / 3600
        let minutes = Int(accumulatedTime) / 60 % 60
        let seconds = Int(accumulatedTime) % 60

        if hours != 0 {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }

        return String(format: "%02i:%02i", minutes, seconds)
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
