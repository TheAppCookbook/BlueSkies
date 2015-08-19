//
//  AirportView.swift
//  BlueSkies
//
//  Created by PATRICK PERINI on 8/19/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import MapKit

class AirportView: MKAnnotationView {
    // MARK: Properties
    private var centerView: UIView?
    private var backgroundView: UIView?
    
    override var tintColor: UIColor! {
        didSet {
            self.backgroundView?.layer.borderColor = self.tintColor.CGColor
            self.centerView?.backgroundColor = self.tintColor
        }
    }
    
    // MARK: Initializers
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRectMake(0, 0, 20, 20)
        self.layer.masksToBounds = true
        
        // Background View
        self.backgroundView?.removeFromSuperview()
        
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.layer.borderColor = self.tintColor.CGColor
        self.backgroundView?.layer.borderWidth = 1.0
        
        let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        scaleAnimation.duration = 1.0
        scaleAnimation.repeatCount = HUGE
        scaleAnimation.autoreverses = true
        scaleAnimation.fromValue = 0.9
        scaleAnimation.toValue = 0.5
        
        self.backgroundView?.layer.removeAllAnimations()
        self.backgroundView?.layer.addAnimation(scaleAnimation, forKey: nil)
        
        self.backgroundView?.layer.cornerRadius = max(self.frame.width, self.frame.height) / 2.0
        self.backgroundView?.layer.masksToBounds = true
        
        self.addSubview(self.backgroundView!)
        
        // Center View
        self.centerView?.removeFromSuperview()
        
        self.centerView = UIView(frame: CGRectInset(self.bounds, self.bounds.width / 3.0, self.bounds.height / 3.0))
        self.centerView?.backgroundColor = self.tintColor.colorWithAlphaComponent(0.70)
        
        self.centerView?.layer.cornerRadius = max(self.centerView!.frame.width, self.centerView!.frame.height) / 2.0
        self.centerView?.layer.masksToBounds = true
        
        self.addSubview(self.centerView!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
