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
    @State private var mapSpanDeltaValue: Double = 0.008

    @State private var vOffset: CGFloat = .zero

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
        .overlay(alignment: .center, content: mapControls)
        .overlay(alignment: .bottom, content: toggleRideButton)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }

    // MARK: - ViewBuilders 

    @ViewBuilder func headerView() -> some View {
        let isRideStarted = rideViewModel.isRideStarted
        let currentSpeed = round(100 * (3.6 * (locationManager.cyclingSpeed ?? .nan))) / 100
        let currentDistance = round(100 * locationManager.cyclingTotalDistance / 1000) / 100

        ZStack(alignment: .top) {
            Pallete.accentColor
                .clipShape(RoundedShape(corners: [.bottomLeft, .bottomRight], radius: 20))
                .ignoresSafeArea()
                .frame(height: (isRideStarted ? 120 : 75) - vOffset)

            VStack {
                Text("Новая поездка")
                    .font(.largeTitle)
                    .bold()
                    .hCenter()
                    .overlay(alignment: .leading) {
                        if !isRideStarted {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: Images.back)
                                    .font(.title2)
                                    .bold()
                                    .padding()
                            }
                        }
                    }

                if isRideStarted, vOffset == .zero {
                    Group {
                        Text("Скорость: \(Int(currentSpeed)) км/ч")
                        Text("Путь: \(String(format: "%.2f", currentDistance)) км")
                    }
                    .font(.title2)
                    .bold()
                }
            }
            .foregroundStyle(.white)
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if isRideStarted {
                        withAnimation {
                            vOffset = -value.translation.height / 5
                        }
                    }
                }
                .onEnded { value in
                    if isRideStarted {
                        withAnimation {
                            if abs(vOffset) > 20 {
                                vOffset = 45
                            } else {
                                vOffset = .zero
                            }
                        }
                    }
                }
        )
        .onChange(of: isRideStarted) { _ in
            withAnimation {
                vOffset = .zero
            }
        }
        .animation(.easeIn, value: isRideStarted)
    }

    @ViewBuilder func mapControls() -> some View {
        VStack {
            if shouldCenterMapOnLocation {
                mapSpanControls()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .scaleEffect(shouldCenterMapOnLocation ? 1 : 0.2)
            }

            Button {
                shouldCenterMapOnLocation.toggle()
            } label: {
                Image(systemName: shouldCenterMapOnLocation ? "lock" : "lock.open")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .padding(3)
                    .frame(width: 40, height: 40)
                    .background(
                        Pallete.accentColor
                    )
                    .cornerRadius(5)
                    .animation(.none, value: shouldCenterMapOnLocation)
            }
            .buttonStyle(MainButtonStyle())
            .hTrailing()
        }
        .padding(.trailing)
        .animation(.default, value: shouldCenterMapOnLocation)
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
                Pallete.accentColor
                    .opacity(0.54)
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
                    mapSpanDeltaValue = max(mapSpanDeltaValue - 0.008, 0.008)
                }
            }

            mapSpanControlButton(imageName: "minus") {
                withAnimation {
                    mapSpanDeltaValue += 0.008
                }
            }
        }
        .hTrailing()
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
                    Pallete.accentColor
                )
                .cornerRadius(5)
        }
        .buttonStyle(MainButtonStyle())
    }

    // MARK: - Private Funcations

    private func toggleRideButtonAction() {
        if rideViewModel.isRideStarted {
            persistRide()
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
            
            rideViewModel.endRide()
            locationManager.endRide()
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
