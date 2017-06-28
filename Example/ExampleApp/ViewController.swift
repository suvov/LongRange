//
//  ViewController.swift
//  ExampleApp
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import UIKit
import MapKit
import LongRange


class ViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.isRotateEnabled = false
            mapView.addAnnotation(rangeFromPin)
            addTapRecognizerToMapView()
            mapView.delegate = self
        }
    }
    
    private var rangeFromPin = MKPointAnnotation()
    
    private var rangeFromCoordinate = CLLocationCoordinate2D() {
        didSet {
            rangeFromPin.coordinate = rangeFromCoordinate
            mapView.addAnnotation(rangeFromPin)
            mapView.setCenter(rangeFromCoordinate, animated: true)
            updateRangeOverlayProvider()
        }
    }
    
    fileprivate var rangeOverlayProvider: RangeOverlayProviding?
    
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeFromCoordinate = CLLocationCoordinate2D(latitude: 51.5072, longitude: 0.1275)
    }
    
    private func updateRangeOverlayProvider() {
        let rangeObjects = [RangeObject(rangeMeters: 4000000, color: .red), RangeObject(rangeMeters: 3000000, color: .green), RangeObject(rangeMeters: 5000000, color: .white)]
        
        let rangeCoordinatesCalculator = RangeCoordinatesCalculator()
        
        let distanceCalculator = DistanceCalculator()
        
        let overlayMaker = MKOverlayMaker(rangeCoordinatesCalculating: rangeCoordinatesCalculator, distanceCalculating: distanceCalculator)
        
        rangeOverlayProvider = RangeOverlayProvider(rangeObjects: rangeObjects, rangeFromCoordinate:rangeFromCoordinate, overlayMaking:overlayMaker)
        
        mapView.removeOverlays(mapView.overlays)
        
        mapView.addOverlays(rangeOverlayProvider!.overlays)
    }
    
    private func addTapRecognizerToMapView() {
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.mapTapped(_:)))
        singleTapRecognizer.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(singleTapRecognizer)
    }
    
    
    // MARK: -
    
    func mapTapped(_ recognizer:UITapGestureRecognizer) {
        let point = recognizer.location(in: mapView)
        rangeFromCoordinate = mapView.convert(point, toCoordinateFrom: mapView)
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let rangeOverlayProvider = rangeOverlayProvider, let renderer = rangeOverlayProvider.rendererForOverlay(overlay) {
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
