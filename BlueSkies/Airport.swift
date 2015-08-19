//
//  Airport.swift
//  BlueSkies
//
//  Created by PATRICK PERINI on 8/19/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import MapKit
import CHCSVParser

class Airport: NSObject, MKAnnotation {
    // MARK: Caches
    private static var allCached: [Airport]?
    
    // MARK: Properties
    dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.invalidCoordinate
    var title: String?
    
    // MARK: Initializers
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.coordinate = coordinate
    }
    
    // MARK: Class Accessors
    class func all(completion: ([Airport]) -> Void) {
        if Airport.allCached != nil {
            completion(Airport.allCached!)
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let fileURL = NSBundle.mainBundle().URLForResource("airports", withExtension: "dat")
            let airports: [Airport] = (NSArray(contentsOfCSVURL: fileURL, options: nil) as! [NSArray]).map { (arr: NSArray) in
                let title = arr[4] as! String
                let lat = CLLocationDegrees((arr[6] as! NSString).doubleValue)
                let lon = CLLocationDegrees((arr[7] as! NSString).doubleValue)
                
                let airport = Airport(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                airport.title = title
                
                return airport
            }
            
            Airport.allCached = airports
            dispatch_async(dispatch_get_main_queue()) {
                completion(airports)
            }
        }
    }
    
    // MARK: Accessors
    func airportWithinDistance(distance: CLLocationDistance) -> Airport {
        let currentLocation = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        return Airport.allCached!.filter({
            let location = CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
            let locationDistance = currentLocation.distanceFromLocation(location)
            
            return locationDistance > (distance / 10.0) && locationDistance < distance
        }).random()!
    }
}
