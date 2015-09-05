//
//  SwapSegue.swift
//  Blue Skies
//
//  Created by PATRICK PERINI on 9/5/15.
//  Copyright © 2015 AppCookbook. All rights reserved.
//

import UIKit

class SwapSegue: UIStoryboardSegue {
    override func perform() {
        self.sourceViewController.presentViewController(self.destinationViewController,
            animated: false,
            completion: nil)
    }
}
