//
//  LocationExtensions.swift
//  BlueSkies
//
//  Created by PATRICK PERINI on 8/19/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import CoreLocation
import CoreGraphics

extension CLLocationCoordinate2D {
    static let invalidCoordinate = CLLocationCoordinate2D(latitude: -1, longitude: -1)
}

extension CLLocation {
    // MARK: Accessors
    func headingToLocation(location: CLLocation) -> CLLocationDegrees {
        let lat1 = self.coordinate.latitude.toRadians()
        let lon1 = self.coordinate.longitude.toRadians()
        
        let lat2 = location.coordinate.latitude.toRadians()
        let lon2 = location.coordinate.longitude.toRadians()
        
        let latDiff = lat2 - lat1
        let lonDiff = lon2 - lon1
        
        var angle = atan2(lonDiff, latDiff) * CGFloat(180.0 / M_PI)
        if angle < 0 {
            angle += 360.0
        }
        
        return CLLocationDegrees(angle)
    }
}

extension CLLocationDegrees {
    func toRadians() -> CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}

extension CGFloat {
    func toDegrees() -> CLLocationDegrees {
        return CLLocationDegrees(CGFloat(self) * 180.0 / CGFloat(M_PI))
    }
}