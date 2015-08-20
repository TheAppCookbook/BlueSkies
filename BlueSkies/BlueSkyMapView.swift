//
//  BlueSkyMapView.swift
//  BlueSkies
//
//  Created by PATRICK PERINI on 8/19/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import MapKit

class BlueSkyMapView: MKMapView {
    // MARK: Class Constants
    private static let urlTemplate = "https://api.mapbox.com/v4/adavis9691.c3c287e6/{z}/{x}/{y}.png?" +
        "access_token=pk.eyJ1IjoiYWRhdmlzOTY5MSIsImEiOiIzYzkwMzc3YjQwNDQ2ZjQ2ZjdmOTk4OGM5YTBkMTY1ZiJ9.uFJU8870yZlBTxAJapxqrA"
    
    
    // MARK: Initializers
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let tileOverlay = MKTileOverlay(URLTemplate: BlueSkyMapView.urlTemplate)
        tileOverlay.canReplaceMapContent = true
        
        self.addOverlay(tileOverlay, level: MKOverlayLevel.AboveLabels)
        self.addOverlay(BlueSkyMapViewGradientOverlay(), level: MKOverlayLevel.AboveLabels)
    }
}

class BlueSkyMapViewGradientOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var boundingMapRect: MKMapRect = MKMapRectWorld
}

class BlueSkyMapViewGradientOverlayRenderer: MKOverlayRenderer {
    // MARK: Properties
    private var gradient: CGGradientRef?
    private let gradientColors = [
        UIColor(red: 0.02, green: 0.43, blue: 0.77, alpha: 0.80),
        UIColor(red: 0.85, green: 0.96, blue: 1.00, alpha: 0.80)
    ]
    
    override init!(overlay: MKOverlay!) {
        super.init(overlay: overlay)
    }
    
    private func updateGradient() {
        if self.gradient != nil { self.gradient = nil }
        
        let colors = self.gradientColors
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorSpaceModel = CGColorSpaceGetModel(colorSpace)
        
        let gradientColors: NSArray = colors.map { (color: UIColor) -> AnyObject! in
            let cgColor = color.CGColor
            let cgColorSpace = CGColorGetColorSpace(cgColor)
            
            // The color's color space is RGB, simply add it.
            if CGColorSpaceGetModel(cgColorSpace).value == colorSpaceModel.value {
                return cgColor as AnyObject!
            }
            
            // Convert to RGB. There may be a more efficient way to do this.
            var red: CGFloat = 0
            var blue: CGFloat = 0
            var green: CGFloat = 0
            var alpha: CGFloat = 0
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return UIColor(red: red, green: green, blue: blue, alpha: alpha).CGColor as AnyObject!
        }
        
        // TODO: This is ugly. Surely there is a way to make this more concise.
        self.gradient = CGGradientCreateWithColors(colorSpace, gradientColors, nil)
    }
    
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext!) {
        self.updateGradient()
        
        if let gradient = self.gradient {
            let rect = self.rectForMapRect(self.overlay.boundingMapRect)
            CGContextDrawLinearGradient(context,
                gradient,
                CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMinY(rect)),
                CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMaxY(rect)),
                CGGradientDrawingOptions.allZeros)
        }
    }
}