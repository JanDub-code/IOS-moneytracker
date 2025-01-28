import SwiftUI
import MapKit

struct MapWithPointsView: UIViewRepresentable {
    var purchases: [PurchaseItem]
    var storeViewModel: StoreViewModel = StoreViewModel()
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapWithPointsView
        var purchases: [PurchaseItem]
        var storeViewModel: StoreViewModel = StoreViewModel()

        init(_ parent: MapWithPointsView, purchases: [PurchaseItem]) {
            self.parent = parent
            self.purchases = purchases
        }
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        addAnnotations(mapView: mapView)
        addPolyline(mapView: mapView)
        setCamera(mapView: mapView, distance: calculateCameraDistance())

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        addAnnotations(mapView: mapView)
        addPolyline(mapView: mapView)
        setCamera(mapView: mapView, distance: calculateCameraDistance())
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, purchases: purchases)
    }

    private func addAnnotations(mapView: MKMapView) {
        for location in purchases {
            let date = location.date
            let calendar = Calendar.current
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)

            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude ?? 0.0, longitude: location.longitude ?? 0.0)
            annotation.title = storeViewModel.findStoreById(id: UUID(uuidString: location.store ?? UUID().uuidString) ?? UUID())?.name
            annotation.subtitle = "\(day).\(month)"
            
            mapView.addAnnotation(annotation)
        }
    }

    private func addPolyline(mapView: MKMapView) {
        var coordinates: [CLLocationCoordinate2D] = []
        
        for location in purchases {
            coordinates.append(CLLocationCoordinate2D(latitude: location.latitude ?? 0.0, longitude: location.longitude ?? 0.0))
        }

        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
    
    private func calculateCameraDistance() -> CLLocationDistance {
        guard purchases.count > 1 else {
            return 1000 // Default distance if only one purchase
        }
        var maxDistance: CLLocationDistance = 0
        for i in 0..<purchases.count {
            for j in i+1..<purchases.count {
                let location1 = CLLocation(latitude: purchases[i].latitude ?? 0.0, longitude: purchases[i].longitude ?? 0.0)
                let location2 = CLLocation(latitude: purchases[j].latitude ?? 0.0, longitude: purchases[j].longitude ?? 0.0)
                let distance = location1.distance(from: location2)
                if distance > maxDistance {
                    maxDistance = distance
                }
            }
        }
        return maxDistance * 8.5 // Add some padding to the distance
    }

    private func setCamera(mapView: MKMapView, distance: CLLocationDistance) {
        guard let firstPurchase = purchases.first else { return }
        
        let camera = MKMapCamera(
            lookingAtCenter: CLLocationCoordinate2D(latitude: firstPurchase.latitude ?? 0.0, longitude: firstPurchase.longitude ?? 0.0),
            fromDistance: distance,
            pitch: 0,
            heading: 0
        )
        mapView.setCamera(camera, animated: true)
    }
}

extension MapWithPointsView.Coordinator {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
}
