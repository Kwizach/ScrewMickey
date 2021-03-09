//
//  DataToCraft.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 11/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//
import UIKit
import Foundation
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public var scannedTicket : DataToCraft = DataToCraft(string: "")

public var savedNumbers : [DataToCraft] = []

func checkIfDataAlreadyInSavedNumbers(_ data: DataToCraft) -> Bool {
    for aData in savedNumbers {
        if aData.leText == data.leText {
            return true
        }
    }
    return false
}


public struct DataToCraft {
    
    public enum Typage {
        case anyText
        case entier
        case userAccepted
        case sql
    }
    
    public var leType : Typage = .anyText
    public var leText : String = ""
    
    // MARK: - Inits
    
    public init(string: String) {
        setText(string)
    }
    
    public init(string: String, type: Typage) {
        leText = string
        leType = type
    }
    
    // MARK: - Operations
    
    public mutating func setText(_ str : String) {
        leText = str
        if isEntier() {
            leType = .entier
        }
        else {
            leType = .anyText
        }
    }
    
    public mutating func getRandomlyInRange(_ lowerValue: String, range : Int) {
        let randomNum = Int(arc4random_uniform(UInt32(range)) + 1)
        self.leText = lowerValue
        self.incrementText(randomNum)
    }
    
    public mutating func incrementText(_ step : Int) {
        if leType == .entier || leType == .userAccepted {
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
    
    fileprivate func splitEntier(_ lEntier : String) -> (String, String) {
        let leDebut = lEntier.substring(to: lEntier.characters.index(lEntier.endIndex, offsetBy: -15))
        let laFin = lEntier.substring(from: lEntier.characters.index(lEntier.endIndex, offsetBy: -15))
        
        return (leDebut, laFin)
    }
    
    fileprivate func numberOfLeadingZeros(_ str: String) -> Int {
        var num : Int = 0
        var laStr = str
        
        if  laStr.remove(at: laStr.startIndex) == "0" {
            num += 1
            num += numberOfLeadingZeros(laStr)
        }
        else {
            return 0
        }
        return num
    }
    
    public func isGreaterThan(_ second: String) -> Bool {
        let premier = self.leText
        
        if premier.characters.count > second.characters.count {
            return true
        }
        
        if premier.characters.count > 18 && second.characters.count > 18 {
            let (_, laFinPremier) = splitEntier(premier)
            let (_, laFinSecond) = splitEntier(second)
            
            if UInt64(laFinPremier) > UInt64(laFinSecond) {
                return true
            }
            else {
                return false
            }
        }
        else {
            if UInt64(premier) > UInt64(second) {
                return true
            }
            else {
                return false
            }
        }
    }
    
    // MARK: - isMickey
    
    public func isEntier() -> Bool {
        if self.leText == "" {
            return false
        }
        let regexNumbersOnly = try! NSRegularExpression(pattern: ".*[^0-9].*", options: [])
        return regexNumbersOnly.firstMatch(in: self.leText, options: [], range: NSMakeRange(0, self.leText.characters.count)) == nil
    }
    
    public func isMickeyType() -> Bool {
        if self.leType == .userAccepted || (isEntier() && self.leText.characters.count == 21) {
            return true
        }
        return false
    }
}

// Helper for alert when the ticket is not in the expected format
public func alertThatItIsNotAValidMickeyCode(_ me: UIViewController, actionCancel: ((UIAlertAction)->())?, actionOK: ((UIAlertAction)->())?) {
    
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
            scannedTicket.leType = .userAccepted
            DispatchQueue.main.async(execute: {
                _ = me.navigationController?.popViewController(animated: true)
            })
            return
        }
    }
    else {
        actionForOK = actionOK!
    }
    
    
    if !scannedTicket.isMickeyType() {
        // Show an Alert
        let alert = UIAlertController(title: "Not a Disney's ticket format", message: "Use it anyway ?", preferredStyle: UIAlertControllerStyle.alert)
        
        // Add actions
        // Cancel we just stay here and remove scannedTicket value
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: actionForCancel))
        // OK
        // We keep the saved value in scannedTicket and move back to previous view
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: actionForOK))
        me.present(alert, animated: true, completion: nil)
    }
    else {
        // Format looks good move back to previous view
        _ = me.navigationController?.popViewController(animated: true)
    }
}

