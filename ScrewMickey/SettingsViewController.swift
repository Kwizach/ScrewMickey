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
    
    var errorCorrectionList = QRCode.ErrorCorrection.allFullValues
    var errorCorrectionShortList = QRCode.ErrorCorrection.allValues
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register for keyboard notifications
        /*NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        */
    }
    
    override func viewWillAppear(animated: Bool) {
        // show settings as we know them
        
        // Timer
        timerLabel.text = "\(configQrafter.timeBetweenCraft)"
        timerSlider.setValue(Float(configQrafter.timeBetweenCraft), animated: true)
        
        // Steps
        stepsTextField.text = "\(configQrafter.incrementationValue)"
        
        // Picker View
        if let row = errorCorrectionShortList.indexOf(configQrafter.errorCorrection.rawValue) {
            errorCorrectionPicker.selectRow(row, inComponent: 0, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Manage Keyboard
    
    // Tell all controls in the view that they are not in editing mode
    // remove the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Remove keyboard when return  is press
    // use UITextFieldDelegate
    // No need for this keypad
    
    @IBAction func stepsEndEditing(sender: UITextField) {
        if sender.text != nil {
            configQrafter.incrementationValue = Int(sender.text!)!
        }
        else {
            configQrafter.incrementationValue = configQrafter.incrementationValueDefault
            sender.text = "\(configQrafter.incrementationValueDefault)"
        }
    }
    
    // MARK: - Slider
    
    @IBAction func timerSliderChanged(sender: UISlider) {
        let laValeur = timerValue()
        timerLabel.text = "\(laValeur)"
        configQrafter.timeBetweenCraft = laValeur
    }
    
    func timerValue() -> Double {
        return Double(roundf(timerSlider.value * 2.0)) * 0.5;
    }
    
    // MARK: - PickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return errorCorrectionList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return errorCorrectionList[row]
    }
    
    // React to selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        configQrafter.errorCorrection = QRCode.ErrorCorrection(rawValue: QRCode.ErrorCorrection.allValues[row])!
    }
    
    
    
    // MARK: - TextFields delgation
    /*
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeField = textField
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if let activeField = self.activeField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!CGRectContainsPoint(aRect, activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
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
