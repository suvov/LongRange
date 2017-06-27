//
//  RangeObject.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//


public protocol RangeObjectProtocol {
    
    var rangeMeters: Double { get }
    var color: COLOR { get }
}

public struct RangeObject:RangeObjectProtocol {
    
    public let rangeMeters: Double
    public let color: COLOR
    
    public init(rangeMeters: Double, color: COLOR) {
        self.rangeMeters = rangeMeters
        self.color = color
    }
}
