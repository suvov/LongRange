//
//  TestRangeCoordinatesCalculator.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import XCTest
import MapKit


@testable import LongRange

class TestRangeCoordinatesCalculator: XCTestCase {
    
    func testThatRangeCoordinatesCalculatorReturnsRightNumberOfCoordinates() {
        let calculator = RangeCoordinatesCalculator()
        let count = calculator.coordinatesForRangeMeters(10000, fromCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), numCoordinatesMinusOne: 10).count
        XCTAssertEqual(count, 11)
    }
}
