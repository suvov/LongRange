//
//  CoordinatesArray+Functions.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import MapKit


extension Array where Iterator.Element == CLLocationCoordinate2D {
    
    var isSpanningAntimeridian: Bool {
        let coordinates = self
        guard var previousLongitude = coordinates.first?.longitude else { return false }
        
        for coordinate in coordinates {
            if((coordinate.longitude < 0 && previousLongitude > 150) || (coordinate.longitude > 150 && previousLongitude < 0)) {
                return true
            }
            previousLongitude = coordinate.longitude
        }
        return false
    }
    
    func closePathOnNorthPole() -> [CLLocationCoordinate2D] {
        let northMostLatitude = 90.0
        return closePathWithExtremeLatitude(northMostLatitude)
    }
    
    func closePathOnSouthPole() -> [CLLocationCoordinate2D] {
        let southMostLatitude = -90.0
        return closePathWithExtremeLatitude(southMostLatitude)
    }

    func addTransCoordinatesForPathThatSpansAntimeridian() -> [CLLocationCoordinate2D] {
        let coordinates = self
        var newCoordinates = [CLLocationCoordinate2D]()
        for (index, coordinate) in coordinates.enumerated() {
            newCoordinates.append(coordinate)
            if index < coordinates.count-1 {
                let nextCoordinate = coordinates[index+1]
                let averageLatitude = (coordinate.latitude + nextCoordinate.latitude)/2
                if coordinate.longitude < 0 && nextCoordinate.longitude > 0 {
                    newCoordinates.append(CLLocationCoordinate2DMake(averageLatitude, -180))
                    newCoordinates.append(CLLocationCoordinate2DMake(averageLatitude, 180))
                } else if coordinate.longitude > 0 && nextCoordinate.longitude < 0 {
                    newCoordinates.append(CLLocationCoordinate2DMake(averageLatitude, 180))
                    newCoordinates.append(CLLocationCoordinate2DMake(averageLatitude, -180))
                }
            }
        }
        return newCoordinates
    }
    
    func splitIntoPositiveAndNegativeLongitude() -> (positive: [CLLocationCoordinate2D], negative: [CLLocationCoordinate2D]) {
        let coordinates = self
        var positive = [CLLocationCoordinate2D]()
        var negative = [CLLocationCoordinate2D]()
        for index in 0..<coordinates.count {
            let coordinate = coordinates[index]
            if coordinate.longitude > 0 {
                positive.append(coordinate)
            } else {
                negative.append(coordinate)
            }
        }
        return (positive, negative)
    }

    // MARK: -
    private func closePathWithExtremeLatitude(_ extremeLatitude: CLLocationDegrees) -> [CLLocationCoordinate2D] {
        var coordinates = self
        if let firstCoordinate = coordinates.first {
            let openingCoordinate = CLLocationCoordinate2D(latitude: extremeLatitude, longitude: firstCoordinate.longitude)
            coordinates.insert(openingCoordinate, at: 0)
        }
        
        if let lastCoordinate = coordinates.last {
            let closingCoordinate = CLLocationCoordinate2D(latitude: extremeLatitude, longitude: lastCoordinate.longitude)
            coordinates.append(closingCoordinate)
        }
        
        return coordinates
    }
}
