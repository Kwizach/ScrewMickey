//
//  CrafterViewController.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 11/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import UIKit
import MediaPlayer


class CrafterViewController: UIViewController {
    
    @IBOutlet weak var leQRCode: UIImageView!
    @IBOutlet weak var leLabel: UILabel!
    
    var qrCode = QRCode()
    var data : DataToCraft = DataToCraft(string: "", type: .AnyText)
    
    var odioSession : AVAudioSession = AVAudioSession.sharedInstance()
    var previousVolume : Float?
    
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = configQrafter.lowerRangeValue
    }
    
    override func viewWillAppear(animated: Bool) {
        // show the QRCode
        showImage()
        
        // Create active AudioSession and Observe Volume Changes
        do {
            // create an active session
            try odioSession.setActive(true)
            // get the initial Volume
            previousVolume = odioSession.outputVolume
            // launch Observer to catch change of Volume
            startObservingVolumeChanges()
            
            // Hide the volume subview
            let volumeView: MPVolumeView = MPVolumeView(frame: CGRectZero)
            view.addSubview(volumeView)
        }
        catch {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopTimer()
        stopObservingVolumeChanges()
        
        do {
            try odioSession.setActive(false)
        }
        catch {
            
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////
    
    // MARK: - QrCode Management
    
    /////////////////////////////////////////////////////////////////////////////
    
    func showImage() {
        qrCode.errorCorrection = configQrafter.errorCorrection
        qrCode.setText(data.leText)
        leQRCode.image = qrCode.image
        leLabel.text = data.leText
    }
    
    func updateCode() {
        data.incrementText( configQrafter.incrementationValue )
        showImage()
    }
    
    /////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Timer Management
    
    /////////////////////////////////////////////////////////////////////////////
    
    func startTimer() {
        let every = configQrafter.timeBetweenCraft
        let steps = configQrafter.incrementationValue
        
        if configQrafter.isUpdatable {
            if timer == nil && every != 0.0 && steps != 0 {
                timer = NSTimer.scheduledTimerWithTimeInterval(every, target: self, selector: Selector("updateCode"), userInfo: nil, repeats: true)
            }
        }
    }
    
    func stopTimer() {
        if configQrafter.isUpdatable {
            if (timer) != nil {
                timer.invalidate()
                timer = nil
            }
        }
    }
    
    @IBAction func playIncrementation(sender: UIBarButtonItem) {
        startTimer()
    }
    
    @IBAction func pauseIncrementation(sender: UIBarButtonItem) {
        stopTimer()
    }
    
    /////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Volume Button Interception
    
    /////////////////////////////////////////////////////////////////////////////
    
    /*private struct Observation {
        static let VolumeKey = "outputVolume"
        static let Context = UnsafeMutablePointer<Void>()
    }*/
    
    func startObservingVolumeChanges() {
        //odioSession.addObserver(self, forKeyPath: Observation.VolumeKey, options: [.Initial, .New], context: Observation.Context)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "volumeChangement:", name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
    }
    
    func volumeChangement(notification: NSNotification) {
        let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        let changeReason = notification.userInfo!["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as! String
        
        if changeReason == "ExplicitVolumeChange" {
            if previousVolume == volume {
                if previousVolume == 0.0 {
                    print("Down")
                }
                else {
                    print("Up")
                }
            }
            else if previousVolume < volume {
                print("Up")
            }
            else {
                print("Down")
            }
        }
        previousVolume = volume
    }
    
    func stopObservingVolumeChanges() {
        //odioSession.removeObserver(self, forKeyPath: Observation.VolumeKey, context: Observation.Context)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
    }
    
    /*
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == Observation.Context {
            if keyPath == Observation.VolumeKey, let volume = (change?[NSKeyValueChangeNewKey] as? NSNumber)?.floatValue {
                // `volume` contains the new system output volume...
                volumeChanged(volume)
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func volumeChanged(volume: Float) {
        
        print("\(previousVolume) --> \(volume)")
        
        if (previousVolume != nil) {
            if previousVolume == volume {
                if previousVolume == 0.0 {
                    print("Down")
                }
                else {
                    print("Up")
                }
            }
            else if previousVolume < volume {
                print("Up")
            }
            else {
                print("Down")
            }
        }
        previousVolume = volume
    }
    */
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
