//
//  RangeObject.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//


public protocol RangeObjectProtocol {
    
    var rangeMeters: Double { get }
    var displayAttributes: RangeObjectDisplayAttributesProtocol? { get }
}

public extension RangeObjectProtocol {
    
    var displayAttributes: RangeObjectDisplayAttributesProtocol? {
        return nil
    }
}

public protocol RangeObjectDisplayAttributesProtocol {
    
    var lineColor: COLOR { get }
    var lineWidth: CGFloat { get }
}

public struct RangeObject: RangeObjectProtocol {
    
    public let rangeMeters: Double
    
    public init(rangeMeters: Double) {
        self.rangeMeters = rangeMeters
    }
    
    private var rangeObjectDisplayAttributes: RangeObjectDisplayAttributes?
    
    public init(rangeMeters: Double, lineColor: COLOR, lineWidth: CGFloat) {
        self.rangeMeters = rangeMeters
        self.rangeObjectDisplayAttributes = RangeObjectDisplayAttributes(lineColor: lineColor, lineWidth: lineWidth)
    }
    
    public var displayAttributes: RangeObjectDisplayAttributesProtocol?  {
        return rangeObjectDisplayAttributes ?? nil
    }
}

fileprivate struct RangeObjectDisplayAttributes: RangeObjectDisplayAttributesProtocol {

    let lineColor: COLOR
    let lineWidth: CGFloat
}
