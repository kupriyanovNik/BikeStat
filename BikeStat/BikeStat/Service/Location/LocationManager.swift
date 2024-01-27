//
//  LocationManager.swift
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    // MARK: - Internal Properties

    @Published var cyclingLastLocation: CLLocation?
    @Published var cyclingLocations: [CLLocation?] = []

    @Published var cyclingSpeed: CLLocationSpeed?
    @Published var cyclingSpeeds: [CLLocationSpeed?] = []

    @Published var cyclingTotalDistance: CLLocationDistance = 0.0

    // MARK: - Inits

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.distanceFilter = 5
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - Private Properties

    private var shouldCount: Bool = false
    private let locationManager = CLLocationManager()

    // MARK: - Internal Functions

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        handleLocationUpdate(for: locations)
    }

    func startRide() {
        shouldCount = true
        clearLocationArray()
    }

    func endRide() {
        shouldCount = false
        clearLocationArray()
    }

    // MARK: - Private Functions

    private func handleLocationUpdate(for locations: [CLLocation]) {
        guard let location = locations.last else { return }

        cyclingLastLocation = location
        cyclingSpeed = max(0, location.speed)

        cyclingLocations.append(cyclingLastLocation)
        cyclingSpeeds.append(cyclingSpeed)

        if cyclingLocations.count > 1, shouldCount {
            let newDistanceInMeters = cyclingLastLocation?.distance(
                from: (cyclingLocations[cyclingLocations.count - 2] ?? cyclingLastLocation)!
            )

            cyclingTotalDistance += newDistanceInMeters ?? 0.0
        }
    }

    private func clearLocationArray() {
        cyclingLocations.removeAll()
        cyclingSpeeds.removeAll()
        cyclingTotalDistance = 0.0
    }
}
