//
//  TestCoordinatesFunctions.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import XCTest
import MapKit


@testable import LongRange

class TestCoordinatesFunctions: XCTestCase {
    
    func testSpanningAntimeridian() {
        XCTAssert(!coordinatesThatDontSpanAntimeridian.isSpanningAntimeridian)
        XCTAssert(coordinatesSpanningAntimeridian.isSpanningAntimeridian)
    }
    
    func testClosePathOnNorthPole() {
        let coordinates = coordinatesThatDontSpanAntimeridian
        
        let closed = coordinates.closePathOnNorthPole()
        
        XCTAssert(closed.first?.latitude == 90)
        XCTAssert(closed.last?.latitude == 90)
    }
    
    func testClosePathOnSouthPole() {
        let coordinates = [CLLocationCoordinate2D(latitude: 45, longitude: 45),
                           CLLocationCoordinate2D(latitude: 44, longitude: 39),
                           CLLocationCoordinate2D(latitude: 44, longitude: 39),
                           CLLocationCoordinate2D(latitude: 44, longitude: -5),
                           CLLocationCoordinate2D(latitude: 44, longitude: -7),
                           CLLocationCoordinate2D(latitude: 44, longitude: -7),
                           CLLocationCoordinate2D(latitude: 44, longitude: -90)]
        let closed = coordinates.closePathOnSouthPole()
        XCTAssert(closed.first?.latitude == -90)
        XCTAssert(closed.last?.latitude == -90)
    }
    
    func testAddTransCoordinatesForPathThatSpansAntimeridian() {
        let coordinates = [CLLocationCoordinate2D(latitude: 45, longitude: -169),
                           CLLocationCoordinate2D(latitude: 46, longitude: 175),
                           CLLocationCoordinate2D(latitude: -47, longitude: 162),
                           CLLocationCoordinate2D(latitude: -44, longitude: -167)]
        let closedCoordinates = coordinates.addTransCoordinatesForPathThatSpansAntimeridian()
        XCTAssert(closedCoordinates.count == 8)
        XCTAssert(closedCoordinates[1].longitude == -180)
        XCTAssert(closedCoordinates[2].longitude == 180)
        XCTAssert(closedCoordinates[5].longitude == 180)
        XCTAssert(closedCoordinates[6].longitude == -180)
    }
    
    
    func testSplitIntoPositiveAndNegativeLongitude() {
        let coordinates = coordinatesThatDontSpanAntimeridian
        
        let split = coordinates.splitIntoPositiveAndNegativeLongitude()
        
        for coordinate in split.negative {
            XCTAssert(coordinate.longitude < 0)
        }
        
        for coordinate in split.positive {
            XCTAssert(coordinate.longitude > 0)
        }
    }
    
    private var coordinatesThatDontSpanAntimeridian:[CLLocationCoordinate2D] {
        return [CLLocationCoordinate2D(latitude: 45, longitude: 45),
                CLLocationCoordinate2D(latitude: 44, longitude: 39),
                CLLocationCoordinate2D(latitude: 44, longitude: 39),
                CLLocationCoordinate2D(latitude: 44, longitude: -5),
                CLLocationCoordinate2D(latitude: 44, longitude: -7),
                CLLocationCoordinate2D(latitude: 44, longitude: -7),
                CLLocationCoordinate2D(latitude: 44, longitude: -90)]
    }
    
    private var coordinatesSpanningAntimeridian:[CLLocationCoordinate2D] {
            return [CLLocationCoordinate2D(latitude: 45, longitude: -169),
                    CLLocationCoordinate2D(latitude: 46, longitude: 175),
                    CLLocationCoordinate2D(latitude: -47, longitude: 162),
                    CLLocationCoordinate2D(latitude: -44, longitude: -167)]

    }
}
