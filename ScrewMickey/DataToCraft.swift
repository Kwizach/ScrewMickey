//
//  DataToCraft.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 11/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//
import UIKit
import Foundation

public var scannedTicket : DataToCraft = DataToCraft(string: "")

public var savedNumbers : [DataToCraft] = []
public var doNotReuseNumbers : [DataToCraft] = []
public var selectionToReplay : [DataToCraft] = []

public struct DataToCraft {
    
    public enum Type {
        case AnyText
        case Entier
        case UserAccepted
        case SQL
    }
    
    public var leType : Type = .AnyText
    public var leText : String = ""
    
    // MARK: - Inits
    
    public init(string: String) {
        setText(string)
    }
    
    public init(string: String, type: Type) {
        leText = string
        leType = type
    }
    
    // MARK: - Functions
    
    public mutating func setText(str : String) {
        leText = str
        if isEntier() {
            leType = .Entier
        }
        else {
            leType = .AnyText
        }
    }
    
    public mutating func incrementText(step : Int) {
        if leType == .Entier || leType == .UserAccepted {
            var laValeur : Int
            
            if leText.characters.count > 15 {
                let (leDebut, laFin) = splitEntier(leText)
                let numOfZeros = numberOfLeadingZeros(laFin)
                
                laValeur = Int(laFin)!
                laValeur += step
                leText = leDebut
                
                for _ in 0 ..< numOfZeros { leText += "0" }
                
                leText += "\(laValeur)"
            }
            else {
                laValeur = Int(leText)!
                laValeur += step
                leText = "\(laValeur)"
            }
        }
    }
    
    private func splitEntier(lEntier : String) -> (String, String) {
        let leDebut = lEntier.substringToIndex(lEntier.endIndex.advancedBy(-15))
        let laFin = lEntier.substringFromIndex(lEntier.endIndex.advancedBy(-15))
        
        return (leDebut, laFin)
    }
    
    private func numberOfLeadingZeros(str: String) -> Int {
        var num : Int = 0
        var laStr = str
        
        if  laStr.removeAtIndex(laStr.startIndex) == "0" {
            num++
            num += numberOfLeadingZeros(laStr)
        }
        else {
            return 0
        }
        return num
    }
    
    // MARK: - isMickey
    
    public func isEntier() -> Bool {
        if self.leText == "" {
            return false
        }
        let regexNumbersOnly = try! NSRegularExpression(pattern: ".*[^0-9].*", options: [])
        return regexNumbersOnly.firstMatchInString(self.leText, options: [], range: NSMakeRange(0, self.leText.characters.count)) == nil
    }
    
    public func isMickeyType() -> Bool {
        if self.leType == .UserAccepted || (isEntier() && self.leText.characters.count == 21) {
            return true
        }
        return false
    }
}

// Helper for alert when the ticket is not in the expected format
public func alertThatItIsNotAValidMickeyCode(me: UIViewController, actionCancel: ((UIAlertAction)->())?, actionOK: ((UIAlertAction)->())?) {
    
    var actionForCancel : (UIAlertAction) -> ()
    var actionForOK     : (UIAlertAction) -> ()
    
    if actionCancel == nil {
        actionForCancel = {
            action in
            scannedTicket = DataToCraft(string: "")
        }
    }
    else {
        actionForCancel = actionCancel!
    }
    
    if actionOK == nil {
        actionForOK = {
            action in
            scannedTicket.leType = .UserAccepted
            dispatch_async(dispatch_get_main_queue(), {
                me.navigationController?.popViewControllerAnimated(true)
            })
            return
        }
    }
    else {
        actionForOK = actionOK!
    }
    
    
    if !scannedTicket.isMickeyType() {
        // Show an Alert
        let alert = UIAlertController(title: "Not a Disney's ticket format", message: "Use it anyway ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add actions
        // Cancel we just stay here and remove scannedTicket value
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: actionForCancel))
        // OK
        // We keep the saved value in scannedTicket and move back to previous view
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: actionForOK))
        me.presentViewController(alert, animated: true, completion: nil)
    }
    else {
        // Format looks good move back to previous view
        me.navigationController?.popViewControllerAnimated(true)
    }
}