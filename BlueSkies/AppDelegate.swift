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
        // Play music
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        self.audioPlayer = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource("Oxygen_Garden", withExtension: "mp3"),
            error: nil)
        self.audioPlayer?.prepareToPlay()
        
        self.audioPlayer?.volume = 1.0
        self.audioPlayer?.numberOfLoops = -1
        
        self.audioPlayer?.play()
    }
}

