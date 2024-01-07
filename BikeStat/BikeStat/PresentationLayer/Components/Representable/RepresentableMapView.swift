//
//  RepresentableMapView.swift
//

import SwiftUI
import MapKit
import CoreLocation

struct RepresentableMapView: UIViewRepresentable {

    // MARK: - Embedded

    final class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(
            _ mapView: MKMapView,
            rendererFor overlay: MKOverlay
        ) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let polylineRenderer = MKPolylineRenderer(overlay: polyline)
                polylineRenderer.strokeColor = .red
                polylineRenderer.lineWidth = 8

                return polylineRenderer
            }

            return MKOverlayRenderer(overlay: overlay)
        }
    }

    // MARK: - Property Wrappers

    @ObservedObject var locationManager: LocationManager

    @Binding var isCycling: Bool
    @Binding var souldCenterMapOnLocation: Bool
    @Binding var cyclingStartTime: Date
    @Binding var mapSpanDeltaValue: Double

    // MARK: - Private Properties

    private var userLocationCoordinate: CLLocationCoordinate2D? {
        locationManager.cyclingLastLocation?.coordinate
    }

    private var userLatitude: String {
        "\(userLocationCoordinate?.latitude ?? 0)"
    }

    private var userLongitude: String {
        "\(userLocationCoordinate?.longitude ?? 0)"
    }

    // MARK: - Internal Functions

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true
        view.removeOverlays(view.overlays)

        let location = CLLocationCoordinate2DMake(
            CLLocationDegrees(userLatitude)!,
            CLLocationDegrees(userLongitude)!
        )
        let span = MKCoordinateSpan(
            latitudeDelta: mapSpanDeltaValue,
            longitudeDelta: mapSpanDeltaValue
        )
        let region = MKCoordinateRegion(center: location, span: span)

        if souldCenterMapOnLocation {
            view.setRegion(region, animated: true)
        }

        if isCycling {
            var locationsToRoute : [CLLocationCoordinate2D] = []

            for location in locationManager.cyclingLocations {
                if let location {
                    locationsToRoute.append(location.coordinate)
                }
            }

            let route = MKPolyline(
                coordinates: locationsToRoute,
                count: locationManager.cyclingLocations.count
            )

            view.addOverlay(route)
        }

        view.delegate = context.coordinator
    }
}
