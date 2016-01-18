//
//  FromTextViewController.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 18/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import UIKit

class FromTextViewController: UIViewController {

    @IBOutlet weak var textToCraft: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textToCraft.layer.borderColor = UIColor.lightGrayColor().CGColor
        textToCraft.layer.borderWidth = 1.0
        textToCraft.layer.cornerRadius = 5.0
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "fromTextToCraft" {
            configQrafter.isUpdatable = false
            configQrafter.lowerRangeValue = DataToCraft(string: textToCraft.text)
            configQrafter.upperRangeValue = DataToCraft(string: "")
        }
    }
}
