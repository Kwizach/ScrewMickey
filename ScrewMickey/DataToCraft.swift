//
//  DataToCraft.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 11/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import Foundation

public var scannedTicket : DataToCraft = DataToCraft(string: "", type: .AnyText)

public var savedNumbers : [DataToCraft]?
public var doNotReuseNumbers : [DataToCraft]?

public struct DataToCraft {
    
    public enum Type {
        case AnyText
        case Entier
        case SQL
    }
    
    public var leType : Type = .AnyText
    public var leText : String = ""
    
    public init(string: String, type: Type) {
        leText = string
        leType = type
    }
    
    public mutating func incrementText(step : Int) {
        if leType == .Entier {
            var laValeur : Int
            
            if leText.characters.count > 15 {
                let (leDebut, laFin) = splitEntier(leText)
                
                laValeur = Int(laFin)!
                laValeur += step
                leText = leDebut
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
        let leDebut = lEntier.substringToIndex(lEntier.endIndex.advancedBy(-14))
        let laFin = lEntier.substringFromIndex(lEntier.endIndex.advancedBy(-15))
        
        return (leDebut, laFin)
    }
    
    public func isEntier() -> Bool {
        return true
    }
}