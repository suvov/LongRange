//
//  MKOverlayMaker+Polyline.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import MapKit


extension MKOverlayMaker {
    
    public func makePolylineForRange(_ rangeMeters: Double, fromCoordinate: CLLocationCoordinate2D) -> MKPolyline? {
        let coordinates = rangeCoordinatesCalculating.coordinatesForRangeMeters(rangeMeters, fromCoordinate: fromCoordinate, numCoordinatesMinusOne: nil)
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
}
