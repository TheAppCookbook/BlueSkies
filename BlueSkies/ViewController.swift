//
//  ViewController.swift
//  BlueSkies
//
//  Created by PATRICK PERINI on 8/19/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var mapView: MKMapView!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jfk = CLLocationCoordinate2D(latitude: 40.639751, longitude: -73.778925)
        let atl = CLLocationCoordinate2D(latitude: 33.636719, longitude: -84.428067)
        
        let plane = Plane(coordinate: jfk)
        self.mapView.addAnnotation(plane)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            let view = self.mapView.viewForAnnotation(plane) as! PlaneView
            view.flyToCoordinate(atl, speed: 200) { () -> Void in
                println("SUCCESS")
            }
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let view = PlaneView(annotation: annotation,
            reuseIdentifier: "")
        view.alpha = 0.0
        return view
    }
}