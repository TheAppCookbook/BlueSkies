//
//  ViewController.swift
//  BlueSkies
//
//  Created by PATRICK PERINI on 8/19/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import MapKit
import ACBInfoPanel

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var exerciseStepInstructionLabel: UILabel!
    @IBOutlet var exerciseStepView: UIView!
    @IBOutlet var exerciseStepIndicators: [UIImageView] = []
    
    @IBOutlet var introViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var introView: UIView!
    @IBOutlet var introInfoLabel: UILabel!
    @IBOutlet var swipeInstructionLabel: UILabel!
    
    private var airports: [Airport] = []
    
    private var mapViewLoaded: Bool = false
    private var fullyLoaded: Bool = false
    
    private var exerciseStep: Int = 0
    private let numberOfExerciseSteps: Int = 2
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Airport.all {
            self.airports = $0
            if self.mapViewLoaded {
                self.finalizeLoad()
            }
        }
        
        if self.exerciseStep != 0 {
            self.introView.removeFromSuperview()
        }
                
    }
    
    private func finalizeLoad() {
        UIView.animateWithDuration(0.33) {
            self.swipeInstructionLabel.alpha = 1.0
        }
        
        self.fullyLoaded = true
    }
    
    // MARK: Responders
    @IBAction func swipeGestureWasRecognized(swipeGestureRecognizer: UISwipeGestureRecognizer!) {
        if !self.fullyLoaded { return }
        
        UIView.animateWithDuration(0.33, animations: {
            self.introViewVerticalConstraint.constant = self.view.bounds.height
            self.introView.layoutIfNeeded()
        }, completion: { (success: Bool) in
            UIView.animateWithDuration(0.33) {
                self.exerciseStepView.alpha = 1.0
            }
            
            if self.exerciseStep == 0 {
                self.performNextExerciseStep()
            }
        })
    }
    
    @IBAction func infoTapGestureWasRecognized(tapGestureRecognizer: UITapGestureRecognizer!) {
        let infoPanel = ACBInfoPanelViewController()
        infoPanel.ingredient = "Flight Anxiety"
        
        self.presentViewController(infoPanel,
            animated: true,
            completion: nil)
    }
    
    // MARK: Exercise Handlers
    private func performNextExerciseStep() {
        if self.exerciseStep == self.numberOfExerciseSteps {
            self.resetExercises()
            return
        }
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let duration = [8.0, 8.0, 12.0, 12.0, 16.0, 20.0][self.exerciseStep]
        let numberOfFlights = [1, 1, 2, 3, 2, 1][self.exerciseStep]
        let delay = 2.0
        
        var airports: [Airport] = []
        
        var planes: [Plane] = []
        var landedPlanes: [Plane] = []
        
        for var flightIndex = 0; flightIndex < numberOfFlights; flightIndex++ {
            let firstAirport: Airport
            if let lastAirport = airports.last {
                firstAirport = lastAirport.airportWithinDistance(5_000_000)
            } else {
                firstAirport = self.airports.random()!
            }
            
            airports.append(firstAirport)
            self.mapView.addAnnotation(firstAirport)
            
            let secondAirport = firstAirport.airportWithinDistance(5_000_000)
            airports.append(secondAirport)
            self.mapView.addAnnotation(secondAirport)
            
            let plane = Plane(coordinate: firstAirport.coordinate)
            planes.append(plane)
            self.mapView.addAnnotation(plane)
            
            dispatch_after(delay, dispatch_get_main_queue()) {
                let planeView = self.mapView.viewForAnnotation(plane) as! PlaneView
                planeView.flyToCoordinate(secondAirport.coordinate, duration: duration) {
                    landedPlanes.append(planeView.annotation as! Plane)
                    
                    if landedPlanes.count == planes.count {
                        self.exerciseStepIndicators[self.exerciseStep].image = UIImage(named: "plane")
                        
                        dispatch_after(delay, dispatch_get_main_queue()) {
                            self.exerciseStep += 1
                            self.performNextExerciseStep()
                        }
                    }
                }
            }
        }
        
        // Animate in/out label
        self.exerciseStepInstructionLabel.text = "Breathe in..."
        UIView.animateWithDuration(0.33, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.exerciseStepInstructionLabel.alpha = 0.5
        }, completion: { (success: Bool) in
            UIView.animateWithDuration(0.33, delay: (duration * 0.5) - 0.66, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.exerciseStepInstructionLabel.alpha = 0.0
            }, completion: { (success: Bool) in
                self.exerciseStepInstructionLabel.text = "Breathe out..."
                UIView.animateWithDuration(0.33, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.exerciseStepInstructionLabel.alpha = 0.5
                }, completion: { (success: Bool) in
                    UIView.animateWithDuration(0.33, delay: (duration * 0.5) - 0.66, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                        self.exerciseStepInstructionLabel.alpha = 0.0
                    }, completion: nil)
                })
            })
        })
        
        // Animate map cross fade
        UIView.animateWithDuration(0.33, animations: {
            self.mapView.alpha = 0.0
        }, completion: { (success: Bool) in
            self.mapView.showAnnotations(airports, animated: false)
            UIView.animateWithDuration(0.33, delay: 1.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.mapView.alpha = 1.0
            }, completion: nil)
        })
    }
    
    private func resetExercises() {
        self.exerciseStep = 0
        self.introInfoLabel.text = Plane.calmingFacts().random()
        
        UIView.animateWithDuration(0.33, animations: {
            self.exerciseStepView.alpha = 0.0
            
            self.introViewVerticalConstraint.constant = 0
            self.introView.layoutIfNeeded()
        }, completion: { (success: Bool) in
            for exerciseStepIndicator in self.exerciseStepIndicators {
                exerciseStepIndicator.image = UIImage(named: "empty-plane")
            }
        })
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
        }
        
        self.mapViewLoaded = true
        if self.airports.count > 0 {
            self.finalizeLoad()
        }
    }
}