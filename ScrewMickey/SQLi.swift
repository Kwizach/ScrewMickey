//
//  SQLi.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 12/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import Foundation

public struct SQLi {
    public enum DBType {
        case mySQL
        case Oracle
        case MSSQL
        case DB2
        case SyBase
    }
    
    public let listOfSQLi = [
        " or 1=1 ",
        " or 1=1 --",
        " or 1=1 #",
        "' or 1=1 ",
        "' or 1=1 --",
        "' or 1=1 #",
        
    ]
    
}