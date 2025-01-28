//
//  PurchaseDetailView.swift
//  MoneyTracker
//
//  Created by Jan Dub on 04.06.2024.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D
    @Binding var isMapPickerPresented: Bool

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
       
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state == .began {
                let mapView = gestureRecognizer.view as! MKMapView
                let locationInView = gestureRecognizer.location(in: mapView)
                let tappedCoordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
                parent.selectedCoordinate = tappedCoordinate
                parent.isMapPickerPresented = false // Dismiss the view here¨
            }
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        addAnnotations(mapView: mapView, selectedCoordinate: selectedCoordinate)
        setCamera(mapView: mapView, selectedCoordinate: selectedCoordinate)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        addAnnotations(mapView: mapView, selectedCoordinate: selectedCoordinate)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    private func addAnnotations(mapView: MKMapView, selectedCoordinate: CLLocationCoordinate2D) {
        // Brno
        let brnoCoordinate = CLLocationCoordinate2D(latitude: 49.1951, longitude: 16.6068)
        let brnoAnnotation = MKPointAnnotation()
        brnoAnnotation.coordinate = brnoCoordinate
        brnoAnnotation.title = "Brno"
        brnoAnnotation.subtitle = "Jiho-moravský kraj"
        mapView.addAnnotation(brnoAnnotation)
        
        // Ostrava
        let ostravaCoordinate = CLLocationCoordinate2D(latitude: 49.8209, longitude: 18.2625)
        let ostravaAnnotation = MKPointAnnotation()
        ostravaAnnotation.coordinate = ostravaCoordinate
        ostravaAnnotation.title = "Ostrava"
        ostravaAnnotation.subtitle = "Moravsko-slezský kraj"
        mapView.addAnnotation(ostravaAnnotation)
        
        // Praha
        let pragueCoordinate = CLLocationCoordinate2D(latitude: 50.0880, longitude: 14.4208)
        let pragueAnnotation = MKPointAnnotation()
        pragueAnnotation.coordinate = pragueCoordinate
        pragueAnnotation.title = "Praha"
        pragueAnnotation.subtitle = "Středočeský kraj"
        mapView.addAnnotation(pragueAnnotation)
        
        let ownCoordinates = selectedCoordinate
        let ownAnnotation = MKPointAnnotation()
        ownAnnotation.coordinate = ownCoordinates
        ownAnnotation.title = "Nákup v tomto místě"
        mapView.addAnnotation(ownAnnotation)
    }
    
    private func setCamera(mapView: MKMapView, selectedCoordinate: CLLocationCoordinate2D) {
        let camera = MKMapCamera(
            lookingAtCenter: CLLocationCoordinate2D(latitude: (selectedCoordinate.latitude == 0.0 ? 49.1951 : selectedCoordinate.latitude), longitude: (selectedCoordinate.longitude == 0.0 ? 16.6068 : selectedCoordinate.longitude)),
            fromDistance: 10000,
            pitch: 0,
            heading: 0
        )
        mapView.setCamera(camera, animated: true)
    }
}
