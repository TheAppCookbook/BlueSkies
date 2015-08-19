//
//  ViewController.swift
//  BlueSkies
//
//  Created by PATRICK PERINI on 8/19/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import MapKit
import GradientView

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var mapView: MKMapView!

    private var airports: [Airport] = []

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Airport.all {
            self.airports = $0
            self.beginExercise()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: Exercise Handlers
    func beginExercise() {
        let firstAirport = self.airports.random()!
        
        self.mapView.centerCoordinate = firstAirport.coordinate
        self.mapView.addAnnotation(firstAirport)
        
        let firstAirportLocation = CLLocation(latitude: firstAirport.coordinate.latitude, longitude: firstAirport.coordinate.longitude)
        let secondAirport = self.airports.filter({
            let location = CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
            let distance = firstAirportLocation.distanceFromLocation(location)
            return distance < 2_500_000
        }).random()!
        
        self.mapView.addAnnotation(secondAirport)
        
        let plane = Plane(coordinate: firstAirport.coordinate)
        self.mapView.addAnnotation(plane)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            let planeView = self.mapView.viewForAnnotation(plane) as! PlaneView
            planeView.flyToCoordinate(secondAirport.coordinate, speed: 200)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var view: MKAnnotationView?
        
        switch annotation {
        case let annotation as Plane:
            view = PlaneView(annotation: annotation,
                reuseIdentifier: "")
            view?.alpha = 0.0
        
        case let annotation as Airport:
            view = mapView.dequeueReusableAnnotationViewWithIdentifier("Airport")
            if view == nil {
                view = AirportView(annotation: annotation,
                    reuseIdentifier: "Airport")
            }
            
            view?.annotation = annotation
            view?.tintColor = UIColor.whiteColor()
            
        default:
            view = MKAnnotationView(annotation: annotation,
                reuseIdentifier: "")
        }
        
        return view!
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let renderer: MKOverlayRenderer
        
        switch overlay {
        case let overlay as MKTileOverlay:
            renderer = MKTileOverlayRenderer(tileOverlay: overlay)
            
        case let overlay as BlueSkyMapViewGradientOverlay:
            renderer = BlueSkyMapViewGradientOverlayRenderer(overlay: overlay)
            renderer.setNeedsDisplay()
            
        default:
            renderer = MKOverlayRenderer(overlay: overlay)
        }
        
        return renderer
    }
}