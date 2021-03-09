//
//  CrafterViewController.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 11/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import UIKit
import MediaPlayer
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



class CrafterViewController: UIViewController {
    
    @IBOutlet weak var leQRCode: UIImageView!
    @IBOutlet weak var leLabel: UILabel!
    
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    
    
    var qrCode = QRCode()
    var data : DataToCraft = DataToCraft(string: "", type: .anyText)
    var indexInListToCraft = 0
    
    var odioSession : AVAudioSession = AVAudioSession.sharedInstance()
    var previousVolume : Float?
    
    var timer: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if configQrafter.craftFromRangeOrList == .range || configQrafter.craftFromRangeOrList == .rangeRandomly {
            data = configQrafter.lowerRangeValue
        }
        else {
            data = configQrafter.listOfValues[indexInListToCraft]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // show the QRCode
        showImage(false)
        
        // Gray buttons if not in 
        if !configQrafter.isUpdatable {
            playButton.isEnabled = false
            pauseButton.isEnabled = false
        }
        
        // Create active AudioSession and Observe Volume Changes
        do {
            // create an active session
            try odioSession.setActive(true)
            // get the initial Volume
            previousVolume = odioSession.outputVolume
            // launch Observer to catch change of Volume
            startObservingVolumeChanges()
            
            // Hide the volume subview
            let volumeView: MPVolumeView = MPVolumeView(frame: CGRect.zero)
            view.addSubview(volumeView)
        }
        catch {}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    func showImage(_ withVibration: Bool) {
        qrCode.errorCorrection = configQrafter.errorCorrection
        qrCode.setText(data.leText)
        leQRCode.image = qrCode.image
        leLabel.text = data.leText
        
        if withVibration {
            // Vibrate
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
    
    func updateCode() {
        if configQrafter.craftFromRangeOrList == .range {
            data.incrementText( configQrafter.incrementationValue )
            
            if(data.isGreaterThan(configQrafter.upperRangeValue.leText)) {
                stopTimer()
            }
            else {
                showImage(configQrafter.withVibration)
            }
        }
        else if configQrafter.craftFromRangeOrList == .rangeRandomly {
            data.getRandomlyInRange(configQrafter.lowerRangeValue.leText, range: configQrafter.rangeLength)
            showImage(configQrafter.withVibration)
        }
        else if configQrafter.craftFromRangeOrList == .list {
            indexInListToCraft += 1
            if(indexInListToCraft < configQrafter.listOfValues.count) {
                data = configQrafter.listOfValues[indexInListToCraft]
                showImage(configQrafter.withVibration)
            }
            else {
                stopTimer()
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Timer Management
    
    /////////////////////////////////////////////////////////////////////////////
    
    func startTimer() {
        let every = configQrafter.timeBetweenCraft
        let steps = configQrafter.incrementationValue
        
        if configQrafter.isUpdatable {
            if timer == nil && every != 0.0 && steps != 0 {
                timer = Timer.scheduledTimer(timeInterval: every, target: self, selector: #selector(CrafterViewController.updateCode), userInfo: nil, repeats: true)
            }
        }
    }
    
    func stopTimer() {
        if configQrafter.isUpdatable {
            if (timer) != nil {
                timer.invalidate()
                timer = nil
                
                playButton.isEnabled = false
                pauseButton.isEnabled = false
            }
        }
    }
    
    @IBAction func playIncrementation(_ sender: UIBarButtonItem) {
        startTimer()
    }
    
    @IBAction func pauseIncrementation(_ sender: UIBarButtonItem) {
        stopTimer()
    }
    
    /////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Volume Button Interception
    
    /////////////////////////////////////////////////////////////////////////////
    
    func startObservingVolumeChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(CrafterViewController.volumeChangement(_:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    func volumeChangement(_ notification: Notification) {
        let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        let changeReason = notification.userInfo!["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as! String
        
        if changeReason == "ExplicitVolumeChange" {
            if previousVolume == volume {
                if previousVolume == 0.0 {
                    removeTheCode()
                }
                else {
                    saveTheCode()
                }
            }
            else if previousVolume < volume {
                saveTheCode()
            }
            else {
                removeTheCode()
            }
        }
        previousVolume = volume
    }
    
    func saveTheCode() {
        if !checkIfDataAlreadyInSavedNumbers(data) {
            savedNumbers.append(data)
        }
    }
    
    func removeTheCode() {
        if configQrafter.isUpdatable && timer == nil {
            updateCode()
        }
    }
    
    func stopObservingVolumeChanges() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
