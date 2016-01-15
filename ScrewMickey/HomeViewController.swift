//
//  HomeViewController.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 14/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    @IBOutlet var optionTable: UITableView!
    @IBOutlet weak var ourTicket: UITableViewCell!
    @IBOutlet weak var rangeCell: UITableViewCell!
    @IBOutlet weak var savedNumbersCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if scannedTicket.leText != "" && scannedTicket.leType == .Entier {
            ourTicket.textLabel?.text = scannedTicket.leText
            statusRangeCell(true)
        }
        else {
            statusRangeCell(false)
        }
        
        if (savedNumbers != nil) {
            statusSavedNumbersCell(true)
        }
        else {
            statusSavedNumbersCell(false)
        }
        
        optionTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func statusRangeCell(status: Bool) {
        rangeCell.userInteractionEnabled = status
        rangeCell.textLabel?.enabled = status
    }
    
    func statusSavedNumbersCell(status: Bool) {
        savedNumbersCell.userInteractionEnabled = status
        savedNumbersCell.textLabel?.enabled = status
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
