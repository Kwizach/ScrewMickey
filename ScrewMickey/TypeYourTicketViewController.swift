//
//  TypeYourTicketViewController.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 17/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import UIKit

class TypeYourTicketViewController: UIViewController {

    @IBOutlet weak var numTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // make the textField First Responder, makes the keyboard appear
        numTextField.becomeFirstResponder()
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
    
    // MARK: - TextField
    @IBAction func numCahnged(_ sender: UITextField) {
        scannedTicket = DataToCraft(string: sender.text!)
        if scannedTicket.isMickeyType() {
            sender.textColor = .green
        }
        else {
            sender.textColor = .black
        }
    }
    
    // MARK: - Button
    
    @IBAction func clickedOKButton(_ sender: UIButton) {
        if numTextField.text != nil {
            alertThatItIsNotAValidMickeyCode(self, actionCancel: nil, actionOK: nil)
        }
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
