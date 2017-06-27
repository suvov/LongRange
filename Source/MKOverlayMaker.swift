//
//  MKOverlayMaker.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import MapKit


public protocol MKOverlayMaking {
    
    func makePolylineForRange(_ rangeMeters: Double, fromCoordinate: CLLocationCoordinate2D) -> MKPolyline?
    
    func makePolygonForRange(_ rangeMeters: Double, fromCoordinate: CLLocationCoordinate2D) -> MKPolygon?
}

public struct MKOverlayMaker: MKOverlayMaking {
    
    let rangeCoordinatesCalculating: RangeCoordinatesCalculating
    let distanceCalculating: DistanceCalculating
    
    public init(rangeCoordinatesCalculating: RangeCoordinatesCalculating, distanceCalculating: DistanceCalculating) {
        self.rangeCoordinatesCalculating = rangeCoordinatesCalculating
        self.distanceCalculating = distanceCalculating
    }
}
