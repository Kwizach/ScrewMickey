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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if scannedTicket.leText == "" {
            ourTicket.textLabel?.text = "Scan your ticket for more options"
        }
        else {
            ourTicket.textLabel?.text = scannedTicket.leText
        }
        
        if scannedTicket.isMickeyType() {
            statusRangeCell(true)
            // hide the separator if we hide the typeYourNumberCell
            ourTicket.separatorInset = UIEdgeInsetsMake(0, 0, 0, ourTicket.frame.size.width)
        }
        else {
            statusRangeCell(false)
        }
        
        if savedNumbers.count == 0 {
            statusSavedNumbersCell(false)
        }
        else {
            statusSavedNumbersCell(true)
        }
        
        optionTable.reloadData()
    }
    
    // Tweak to hide the manuallyTypeCell if we did'nt scan it
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 1 && scannedTicket.isMickeyType() {
            return 0.0
        }
        
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func statusRangeCell(_ status: Bool) {
        rangeCell.isUserInteractionEnabled = status
        rangeCell.textLabel?.isEnabled = status
    }
    
    func statusSavedNumbersCell(_ status: Bool) {
        savedNumbersCell.isUserInteractionEnabled = status
        savedNumbersCell.textLabel?.isEnabled = status
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
