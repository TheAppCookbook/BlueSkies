//
//  Airport.swift
//  BlueSkies
//
//  Created by PATRICK PERINI on 8/19/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import MapKit

class Airport: NSObject, MKAnnotation {
    // MARK: Properties
    dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.invalidCoordinate
    
    // MARK: Initializers
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.coordinate = coordinate
    }
}
