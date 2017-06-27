//
//  RangeOverlayProvider.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import MapKit


public  protocol RangeOverlayProviding {
    
    var overlays: [MKOverlay] { get }
    func rendererForOverlay(_ overlay: MKOverlay) -> MKOverlayRenderer?
}

public struct RangeOverlayProvider: RangeOverlayProviding {
    
    var unreachableAreaColor: COLOR = .white
    var unreachableAreaAlpha: CGFloat = 0.8
    var rangeLineWidth: CGFloat = 3.0

    private let rangeObjects: [RangeObjectProtocol]
    private let rangeFromCoordinate: CLLocationCoordinate2D
    private let overlayMaking: MKOverlayMaking
    
    public let overlays: [MKOverlay]
    
    public init(rangeObjects: [RangeObjectProtocol], rangeFromCoordinate: CLLocationCoordinate2D, overlayMaking: MKOverlayMaking) {
        self.rangeObjects = rangeObjects
        self.rangeFromCoordinate = rangeFromCoordinate
        self.overlayMaking = overlayMaking
        var tempOverlays = [MKOverlay]()
        // polylines for range
        for (index, object) in rangeObjects.enumerated() {
            if let overlay = overlayMaking.makePolylineForRange(object.rangeMeters, fromCoordinate: rangeFromCoordinate) {
                overlay.title = "\(index)"
                tempOverlays.append(overlay)
            }
        }
        // polygon for area unreachable by object with highest range
        if let highestRangeObject = rangeObjects.max (by: {a, b in a.rangeMeters < b.rangeMeters }) {
            if let overlay = overlayMaking.makePolygonForRange(highestRangeObject.rangeMeters, fromCoordinate: rangeFromCoordinate) {
                tempOverlays.append(overlay)
            }
        }
        overlays = tempOverlays
    }
    
    public func rendererForOverlay(_ overlay: MKOverlay) -> MKOverlayRenderer? {
        if let polyline = overlay as? MKPolyline {
            return rendererForPolyline(polyline)
        } else if let polygon = overlay as? MKPolygon {
            return rendererForPolygon(polygon)
        }
        return nil
    }
    
    private func rendererForPolyline(_ polyline: MKPolyline) -> MKPolylineRenderer {
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = colorForPolyline(polyline)
        renderer.lineWidth = rangeLineWidth
        return renderer
    }
    
    private func colorForPolyline(_ polyline: MKPolyline) -> COLOR {
        if let title = polyline.title, let index = Int(title) {
            if rangeObjects.indices.contains(index) {
                let rangeObject = rangeObjects[index]
                return rangeObject.color
            }
        }
        return .white
    }
    
    private func rendererForPolygon(_ polygon: MKPolygon) -> MKPolygonRenderer {
        let renderer = MKPolygonRenderer(polygon: polygon)
        renderer.fillColor = unreachableAreaColor
        renderer.alpha = unreachableAreaAlpha
        return renderer
    }
}
