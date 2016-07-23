//
//  ItemsDb.swift
//  metalgalaxy
//
//  Created by AugieD369 on 7/23/16.
//  Copyright © 2016 Aaron Erdman. All rights reserved.
//

import Foundation
import SQLite

let dbPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
let db = try! Connection("\(dbPath)/itemsdb.sqlite3")
let 

class ItemsDb {
    func startDb() {
        
    }
}
