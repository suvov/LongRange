//
//  MKOverlayMaker+Polygon.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import MapKit


extension MKOverlayMaker {
    
    public func makePolygonForRange(_ rangeMeters: Double, fromCoordinate: CLLocationCoordinate2D) -> MKPolygon? {
        var rangeCoordinates = rangeCoordinatesCalculating.coordinatesForRangeMeters(rangeMeters, fromCoordinate: fromCoordinate, numCoordinatesMinusOne: nil)
        
        let canReachNorthPole = distanceCalculating.canReachNorthPoleFromCoordinate(fromCoordinate, rangeMeters: rangeMeters)
        let canReachSouthPole = distanceCalculating.canReachSouthPoleFromCoordinate(fromCoordinate, rangeMeters: rangeMeters)
        
        let cannotReachAnyPole = !canReachNorthPole && !canReachSouthPole
        let canReachBothPoles = canReachNorthPole && canReachSouthPole
        let canReachOnlyNorthPole = canReachNorthPole && !canReachBothPoles
        let canReachOnlySouthPole = canReachSouthPole && !canReachBothPoles
        
        if cannotReachAnyPole {
            return circlePolygonWithCoordinates(rangeCoordinates)
        }
        
        if canReachOnlyNorthPole {
            rangeCoordinates = rangeCoordinates.closePathOnSouthPole()
        } else if canReachOnlySouthPole {
            rangeCoordinates = rangeCoordinates.closePathOnNorthPole()
        }
        
        return polygonWithCoordinates(rangeCoordinates)
    }
    
    private func circlePolygonWithCoordinates(_ rangeCoordinates: [CLLocationCoordinate2D]) -> MKPolygon? {
        let spansAntimeridian = rangeCoordinates.isSpanningAntimeridian
       
        var interiorPolygons = [MKPolygon]()
        
        // if range coordinates span Antimeridian we have to divide resulting polygon into two parts -- western and eastern
        // MKPolygon doesn't automatically span thru Antimeridian when used as interior polygon
        
        if spansAntimeridian {
            interiorPolygons = interiorPolygonsWithCoordinates(rangeCoordinates)
        } else {
            if let polygon = polygonWithCoordinates(rangeCoordinates) {
                interiorPolygons = [polygon]
            }
        }
        return polygonWithCoordinates(worldPolygonCoordinates, interiorPolygons: interiorPolygons)
    }
    
    private func interiorPolygonsWithCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> [MKPolygon] {
        var polygons = [MKPolygon]()
        let closedCoordinates = coordinates.addTransCoordinatesForPathThatSpansAntimeridian()
        let separatedCoordinates = closedCoordinates.splitIntoPositiveAndNegativeLongitude()
        
        let positive = separatedCoordinates.positive
        let negative = separatedCoordinates.negative
        
        if positive.count > 0 {
            if let positiveLongitudePolygon = polygonWithCoordinates(positive) {
                polygons.append(positiveLongitudePolygon)
            }
        }
        if negative.count > 0 {
            if let negativeLongitudePolygon = polygonWithCoordinates(negative) {
                polygons.append(negativeLongitudePolygon)
            }
        }
        return polygons
    }

    private var worldPolygonCoordinates: [CLLocationCoordinate2D] {
        return [CLLocationCoordinate2D(latitude: 90, longitude: 0),
                CLLocationCoordinate2D(latitude: 90, longitude: 180),
                CLLocationCoordinate2D(latitude: -90, longitude: 180),
                CLLocationCoordinate2D(latitude: -90, longitude: 0),
                CLLocationCoordinate2D(latitude: -90, longitude: -180),
                CLLocationCoordinate2D(latitude: 90, longitude: -180)]
    }
    
    private func polygonWithCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> MKPolygon? {
        return MKPolygon(coordinates: coordinates, count: coordinates.count)
    }
    
    private func polygonWithCoordinates(_ coordinates: [CLLocationCoordinate2D], interiorPolygons: [MKPolygon]) -> MKPolygon? {
        return MKPolygon(coordinates: coordinates, count: coordinates.count, interiorPolygons:interiorPolygons)
    }
}
