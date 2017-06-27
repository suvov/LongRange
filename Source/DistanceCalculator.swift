//
//  DistanceCalculator.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import MapKit


public protocol DistanceCalculating {
    
    func canReachNorthPoleFromCoordinate(_ fromCoordinate: CLLocationCoordinate2D, rangeMeters: Double) -> Bool
    
    func canReachSouthPoleFromCoordinate(_ fromCoordinate: CLLocationCoordinate2D, rangeMeters: Double) -> Bool
}

public struct DistanceCalculator: DistanceCalculating {
    
    public init() {}
    
    public func canReachNorthPoleFromCoordinate(_ fromCoordinate: CLLocationCoordinate2D, rangeMeters: Double) -> Bool {
        let northPole = CLLocation(latitude: 90, longitude: 0)
        let metersToNorthPole = northPole.distance(from: CLLocation(latitude: fromCoordinate.latitude, longitude: fromCoordinate.longitude))
        return metersToNorthPole - rangeMeters <= 0
    }
    
    public func canReachSouthPoleFromCoordinate(_ fromCoordinate: CLLocationCoordinate2D, rangeMeters: Double) -> Bool {
        let southPole = CLLocation(latitude: -90, longitude: 0)
        let metersToSouthPole = southPole.distance(from: CLLocation(latitude: fromCoordinate.latitude, longitude: fromCoordinate.longitude))
        return metersToSouthPole - rangeMeters <= 0
    }
}
