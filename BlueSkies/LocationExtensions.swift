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
        
        let deltaLon = lon2 - lon1
        let deltaLat = lat2 - lat1
        
        let y = sin(deltaLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2)
        
        return atan2(y, x).toDegrees()
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