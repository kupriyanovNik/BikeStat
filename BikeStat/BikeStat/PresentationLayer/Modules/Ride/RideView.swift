//
//  RideView.swift
//

import SwiftUI

struct RideView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var rideViewModel: RideViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var themeManager: ThemeManager

    @State private var shouldCenterMapOnLocation: Bool = true
    @State private var mapSpanDeltaValue: Double = 0.008

    @State private var shouldShowInfo: Bool = true

    // MARK: - Private Properties

    private let localizable = Localizable.RideView.self

    private var toggleRideButtonText: String {
        rideViewModel.isRideStarted ? localizable.finish : localizable.start
    }

    private var cyclingTotalDistanceText: String {
        rideViewModel.isRideStarted ?
            ": \(round(locationManager.cyclingTotalDistance / 10) / 100)км" :
            ""
    }

    private var distanceText: String {
        let estimatedDistance = round(
            100 * Double(rideViewModel.currentRide?.estimatedDistance ?? 0) / 1000
        ) / 100

        let currentDistance = round(
            100 * locationManager.cyclingTotalDistance / 1000
        ) / 100

        let currentDistanceString = String(format: .distanceFormat, currentDistance)

        return "\(localizable.distance): \(currentDistanceString)/\(estimatedDistance) км"
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
        .onDisappear {
            rideViewModel.currentRide = nil 
        }
        .onAppear {
            networkManager.getWatchData()
        }
        .onChange(of: rideViewModel.totalAccumulatedTime) { newValue in
            if settingsViewModel.shouldAutomaticlyEndRide {
                if let currentRide = rideViewModel.currentRide {
                    if rideViewModel.totalAccumulatedTime >= Double(currentRide.estimatedTime) {
                        toggleRideButtonAction()
                    }
                }
            }
        }
    }

    // MARK: - ViewBuilders 

    @ViewBuilder func headerView() -> some View {
        let isRideStarted = rideViewModel.isRideStarted
        let isExpanded = isRideStarted && shouldShowInfo

        let currentSpeed = round(
            100 * (3.6 * (locationManager.cyclingSpeed ?? .nan))
        ) / 100

        ZStack(alignment: .top) {
            themeManager.selectedTheme.accentColor
                .clipShape(
                    RoundedShape(
                        corners: [.bottomLeft, .bottomRight], 
                        radius: 20
                    )
                )
                .ignoresSafeArea()
                .frame(height: isExpanded ? 120 : 75)
                .onTapGesture {
                    if isRideStarted {
                        withAnimation {
                            shouldShowInfo.toggle()
                        }
                    }
                }

            VStack {
                Text(localizable.pageTitle)
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

                if isRideStarted, shouldShowInfo {
                    Group {
                        Text("\(localizable.speed): \(Int(currentSpeed)) км/ч")

                        Text(distanceText)
                    }
                    .font(.title2)
                    .bold()
                }
            }
            .foregroundStyle(.white)
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
                Image(
                    systemName: shouldCenterMapOnLocation ? Images.lock : Images.opendedLock
                )
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .padding(3)
                .frame(width: 40, height: 40)
                .background(
                    themeManager.selectedTheme.accentColor
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

                Text(rideViewModel.totalAccumulatedTime.asString())

                Text("/ " + Int(rideViewModel.currentRide?.estimatedTime ?? 0).formatAsTime())
                    .font(.callout)
            }
            .font(.title)
            .bold()
            .foregroundStyle(.white)
            .padding(.vertical)
            .padding(.horizontal, 36)
            .background {
                themeManager.selectedTheme.accentColor
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
        .disabled(
            locationManager.cyclingSpeeds.isEmpty &&
            rideViewModel.isRideStarted
        )
    }

    @ViewBuilder func mapSpanControls() -> some View {
        VStack {
            if #available(iOS 17, *) {
                mapSpanControlButton(imageName: Images.plus) {
                    withAnimation {
                        mapSpanDeltaValue = max(mapSpanDeltaValue - 0.008, 0.008)
                    }
                }
                .buttonRepeatBehavior(.enabled)
            } else {
                mapSpanControlButton(imageName: Images.plus) {
                    withAnimation {
                        mapSpanDeltaValue = max(mapSpanDeltaValue - 0.008, 0.008)
                    }
                }
            }

            if #available(iOS 17, *) {
                mapSpanControlButton(imageName: Images.minus) {
                    withAnimation {
                        mapSpanDeltaValue += 0.008
                    }
                }
                .buttonRepeatBehavior(.enabled)
            } else {
                mapSpanControlButton(imageName: Images.minus) {
                    withAnimation {
                        mapSpanDeltaValue += 0.008
                    }
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
                .background {
                    themeManager.selectedTheme.accentColor
                }
                .cornerRadius(5)
        }
        .buttonStyle(MainButtonStyle())
    }

    // MARK: - Private Funcations

    private func toggleRideButtonAction() {
        if rideViewModel.isRideStarted {
            persistRide()
            dismiss()
        } else {
            rideViewModel.startRide()
            locationManager.startRide()
        }
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

        if let currentRide = rideViewModel.currentRide,
           let pulseData = networkManager.watchData?.data {
            let realComplexity = ComplexityManager.shared
                .getRealComplexity(
                    avgPulse: pulseData.pulse.avg,
                    avgSpeed: avgSpeed
                )
            
            coreDataManager.endRide(
                ride: currentRide,
                pulseData: .init(
                    min: pulseData.pulse.min,
                    avg: pulseData.pulse.avg,
                    max: pulseData.pulse.max
                ),
                speedData: .init(
                    avg: avgSpeed,
                    max: maxSpeed
                ),
                realComplexity: realComplexity.rawValue,
                realDistance: Int(locationManager.cyclingTotalDistance),
                realTime: Int(rideViewModel.totalAccumulatedTime)
            )
        }

        rideViewModel.endRide()
        locationManager.endRide()
    }
}

// MARK: - Preview

#Preview {
    RideView(
        rideViewModel: .init(),
        settingsViewModel: .init(),
        navigationManager: .init(),
        coreDataManager: .init(),
        networkManager: .init(),
        locationManager: .init(),
        themeManager: .init()
    )
}
