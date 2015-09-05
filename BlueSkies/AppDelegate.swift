//
//  AppDelegate.swift
//  BlueSkies
//
//  Created by PATRICK PERINI on 8/19/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Properties
    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    
    func applicationDidBecomeActive(application: UIApplication) {
        self.playMusic()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        self.playMusic()
    }
    
    func playMusic() {
        do {
            // Play music
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("Oxygen_Garden", withExtension: "mp3")!)
        } catch _ {
            self.audioPlayer = nil
        }
        
        self.audioPlayer?.prepareToPlay()
        
        self.audioPlayer?.volume = 1.0
        self.audioPlayer?.numberOfLoops = -1
        
        self.audioPlayer?.play()
    }
}

