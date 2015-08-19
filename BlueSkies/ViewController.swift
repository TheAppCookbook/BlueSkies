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
    @IBOutlet var introView: UIView!
    @IBOutlet var swipeInstructionLabel: UILabel!

    private var airports: [Airport] = []
    private var exerciseStep: Int = 0
    private var mapViewLoaded: Bool = false
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Airport.all { self.airports = $0 }
        
        if self.exerciseStep == 0 {
            
        } else {
           self.introView.removeFromSuperview()
        }
    }
    
    // MARK: Responders
    @IBAction func swipeGestureWasRecognized(swipeGestureRecognizer: UISwipeGestureRecognizer!) {
        if self.mapViewLoaded {
            UIView.animateWithDuration(0.33) {
                var frame = self.introView.frame
                frame.origin = CGPoint(x: frame.origin.x, y: -frame.size.height)
                self.introView.frame = frame
            }
        }
    }
    
    // MARK: Exercise Handlers
    private func performNextExerciseStep() {
        self.exerciseStep += 1
        
        let numberOfFlights: Int
        switch self.exerciseStep {
        case 1, 2, 6:
            numberOfFlights = 1
            
        case 3, 5:
            numberOfFlights = 2
            
        case 4:
            numberOfFlights = 3
            
        default:
            numberOfFlights = 0
        }
        
        var annotations: [MKAnnotation] = []
        for var flightIndex = 0; flightIndex < numberOfFlights; flightIndex++ {
            let firstAirport: Airport
            if let lastAirport = annotations.first as? Airport {
                firstAirport = lastAirport.airportWithinDistance(5_000_000)
            } else {
                firstAirport = self.airports.random()!
            }
            
            annotations.append(firstAirport)
            self.mapView.addAnnotation(firstAirport)
            
            let secondAirport = firstAirport.airportWithinDistance(2_500_000)
            annotations.append(secondAirport)
            self.mapView.addAnnotation(secondAirport)
            
            let plane = Plane(coordinate: firstAirport.coordinate)
            self.mapView.addAnnotation(plane)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                let planeView = self.mapView.viewForAnnotation(plane) as! PlaneView
                planeView.flyToCoordinate(secondAirport.coordinate, speed: 200)
            }
        }
        
        self.mapView.showAnnotations(annotations, animated: true)
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
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        UIView.animateWithDuration(1.33) {
            mapView.alpha = 1.0
            self.swipeInstructionLabel.alpha = 1.0
        }
        
        self.mapViewLoaded = true
    }
}