//
//  ViewController.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 11/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var stepsTextField: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var errorCorrectionPicker: UIPickerView!
    @IBOutlet weak var vibrateSwitch: UISwitch!
    
    var errorCorrectionList = QRCode.ErrorCorrection.allFullValues
    var errorCorrectionShortList = QRCode.ErrorCorrection.allValues
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register for keyboard notifications
        /*NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // show settings as we know them
        
        // Timer
        timerLabel.text = "\(configQrafter.timeBetweenCraft)"
        timerSlider.setValue(Float(configQrafter.timeBetweenCraft), animated: true)
        
        // Steps
        stepsTextField.text = "\(configQrafter.incrementationValue)"
        
        // Picker View
        if let row = errorCorrectionShortList.index(of: configQrafter.errorCorrection.rawValue) {
            errorCorrectionPicker.selectRow(row, inComponent: 0, animated: true)
        }
        // Switch
        vibrateSwitch.isOn = configQrafter.withVibration
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Manage Keyboard
    
    // Tell all controls in the view that they are not in editing mode
    // remove the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Remove keyboard when return  is press
    // use UITextFieldDelegate
    // No need for this keypad
    
    @IBAction func stepsEndEditing(_ sender: UITextField) {
        if sender.text != nil {
            configQrafter.incrementationValue = Int(sender.text!)!
        }
        else {
            configQrafter.incrementationValue = configQrafter.incrementationValueDefault
            sender.text = "\(configQrafter.incrementationValueDefault)"
        }
    }
    
    // MARK: - Slider
    
    @IBAction func timerSliderChanged(_ sender: UISlider) {
        let laValeur = timerValue()
        timerLabel.text = "\(laValeur)"
        configQrafter.timeBetweenCraft = laValeur
    }
    
    func timerValue() -> Double {
        return Double(roundf(timerSlider.value * 2.0)) * 0.5;
    }
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return errorCorrectionList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return errorCorrectionList[row]
    }
    
    // React to selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        configQrafter.errorCorrection = QRCode.ErrorCorrection(rawValue: QRCode.ErrorCorrection.allValues[row])!
    }
    
    @IBAction func withVibrationChanged(_ sender: UISwitch) {
        configQrafter.withVibration = sender.isOn
    }
    
}
