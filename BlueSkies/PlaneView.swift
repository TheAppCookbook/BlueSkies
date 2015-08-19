//
//  PlaneView.swift
//  BlueSkies
//
//  Created by PATRICK PERINI on 8/19/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import MapKit

class PlaneView: MKAnnotationView {
    // MARK: Class Properties
    private static let timeScale: CGFloat = 1000.0
    
    // MARK: Properties
    var coordinate: CLLocationCoordinate2D {
        get { return self.annotation.coordinate }
        set { (self.annotation as! Plane).coordinate = newValue }
    }
    
    // MARK: Initializers
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.image = UIImage(named: "plane")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Animators
    func flyToCoordinate(coordinate: CLLocationCoordinate2D, speed: CGFloat, completion: () -> Void = {}) {
        let startLocation = CLLocation(latitude: self.coordinate.latitude,
            longitude: self.coordinate.longitude)
        let endLocation = CLLocation(latitude: coordinate.latitude,
            longitude: coordinate.longitude)
        
        // Rotate. Rotate for 0%
        self.transform = CGAffineTransformMakeRotation(startLocation.headingToLocation(endLocation).toRadians())
        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1)
        
        let distance = fabs(startLocation.distanceFromLocation(endLocation))
        let duration = NSTimeInterval(CGFloat(distance) / (speed * PlaneView.timeScale))
        
        // Travel. Move for 100%
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.coordinate = endLocation.coordinate
        }, completion: { (success: Bool)  in
            completion()
        })
        
        // Scale. Up for 50%, back Down for 50%
        UIView.animateWithDuration(duration * 0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.transform = CGAffineTransformScale(self.transform,
                10.0, 10.0)
        }, completion: { (success: Bool) in
            UIView.animateWithDuration(duration * 0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.transform = CGAffineTransformScale(self.transform,
                    0.1, 0.1)
            }, completion: nil)
        })
        
        // Fade. In for 33%, back Out for 33%
        UIView.animateWithDuration(duration * 0.33, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alpha = 1.0
        }, completion: { (success: Bool) in
            UIView.animateWithDuration(duration * 0.33, delay: duration * 0.33, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.alpha = 0.0
            }, completion: nil)
        })
    }
}
