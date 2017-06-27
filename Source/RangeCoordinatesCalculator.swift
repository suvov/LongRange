//
//  RangeCoordinatesCalculator.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import MapKit


public protocol RangeCoordinatesCalculating {
    
    func coordinatesForRangeMeters(_ rangeMeters: Double, fromCoordinate: CLLocationCoordinate2D, numCoordinatesMinusOne: Int?) -> [CLLocationCoordinate2D]
}

public struct RangeCoordinatesCalculator: RangeCoordinatesCalculating {
    
    public init() {}
    
    public func coordinatesForRangeMeters(_ rangeMeters: Double, fromCoordinate: CLLocationCoordinate2D, numCoordinatesMinusOne: Int?) -> [CLLocationCoordinate2D] {
        
        let bearingStep = bearingStepWith(numCoordinatesMinusOne: numCoordinatesMinusOne)

        var coordinates = [CLLocationCoordinate2D]()
        let startingBearing = -180.0
        let endingBearing = 180.0
        
        var bearing = startingBearing
        while bearing <= endingBearing {
            let latitude = latitudeForBearing(bearing, fromCoordinate: fromCoordinate, rangeMeters: rangeMeters)
            var longitude = longitudeForBearing(bearing, fromCoordinate: fromCoordinate, rangeMeters: rangeMeters)
            
            if longitude < -180 {
                longitude = 180 + fmod(longitude, 180)
            }
            
            coordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            bearing += bearingStep
        }
        return coordinates
    }
    
    private func bearingStepWith(numCoordinatesMinusOne: Int?) -> Double {
        let totalBearings = 360
        let defaultNumCoordinatesMinusOne = 360
        return Double(totalBearings) / Double(numCoordinatesMinusOne ?? defaultNumCoordinatesMinusOne)
    }

    private func latitudeForBearing(_ bearing: Double, fromCoordinate: CLLocationCoordinate2D, rangeMeters: Double) -> CLLocationDegrees {
        let angularDistance = angularDistanceForRangeMeters(rangeMeters)
        let latitudeRadians = fromCoordinate.latitude.degreesToRadians
        let bearingRadians = bearing.degreesToRadians
        let phi = asin(sin(latitudeRadians) * cos(angularDistance) + cos(latitudeRadians) * sin(angularDistance) * cos(bearingRadians) )
        let latitude = phi.radiansToDegrees
        
        return latitude
    }
    
    private func longitudeForBearing(_ bearing: Double, fromCoordinate: CLLocationCoordinate2D, rangeMeters: Double) -> CLLocationDegrees {
        let angularDistance = angularDistanceForRangeMeters(rangeMeters)
        let latitudeRadians = fromCoordinate.latitude.degreesToRadians
        let longitudeRadians = (fromCoordinate.longitude + 180).degreesToRadians
        let bearingRadians = bearing.degreesToRadians
        let phi = asin(sin(latitudeRadians) * cos(angularDistance) + cos(latitudeRadians) * sin(angularDistance) * cos(bearingRadians) )
        let lambda = atan2( sin(bearingRadians) * sin(angularDistance) * cos(latitudeRadians), cos(angularDistance) - sin(latitudeRadians) * sin(phi) ) + longitudeRadians
        let longitude = ((fmod(lambda, (2 * .pi)) - .pi)).radiansToDegrees
        
        return longitude
    }
    
    private func angularDistanceForRangeMeters(_ rangeMeters: Double) -> Double {
        let kAverageGlobalRadiusMeters = 6378137.00
        return rangeMeters / kAverageGlobalRadiusMeters
    }
}

fileprivate extension FloatingPoint {
    
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
