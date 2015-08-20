//
//  Plane.swift
//  BlueSkies
//
//  Created by PATRICK PERINI on 8/19/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import MapKit

class Plane: NSObject, MKAnnotation {
    // MARK: Properties
    dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.invalidCoordinate
    
    // MARK: Initializers
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.coordinate = coordinate
    }

    // MARK: Class Accessors
    class func calmingFacts() -> [String] {
        return [
            "Over 80,000 planes will fly today without incident. Stay calm, stay happy.",
            "Fewer than 0.000003% of all flights have resulted in an accident. All is well.",
            "Hartsfield-Jackson International Airport will have about 60,000 passengers today. You're in good company.",
            "Each pilot has well over 1,000 hours of flying before flying a commercial airline. You're in good hands.",
            "Many flight attendants will take up to 5 flights today, including yours.",
            "Your flight is 20 times safer than the car ride to the airport. All is well."
        ]
    }
}
