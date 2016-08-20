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
let items = Table("items")
let uuid = Expression<String> ("uuid")
let itemname = Expression<String> ("itemname")
let itemmaker = Expression<String> ("itemmaker")
let itembrand = Expression<String> ("itembrand")
let itemreleasemonth = Expression<String> ("itemreleasemonth")
let itemreleaseyear = Expression<String> ("itemreleaseyear")
let itemavaliable = Expression<Bool> ("itemavaliable")
let itemavaliablereason = Expression<String?> ("itemavaliablereason")
let itemnumberofsheets = Expression<Int64> ("itemnumberofsheets")
let itemdiffculty = Expression<Int64> ("itemdiffculty")
let iteminfoURL = Expression<String?> ("IteminfoURL")
let item360URL = Expression<String?> ("Item360URL")
let defaults = NSUserDefaults.standardUserDefaults()

class ItemsDb {
    func startDb() {
        try! db.run(items.create(ifNotExists: true) {t in
            t.column(uuid, primaryKey: true)
            t.column(itemname, unique: true)
            t.column(itemmaker)
            t.column(itembrand)
            t.column(itemreleasemonth)
            t.column(itemreleaseyear)
            t.column(itemavaliable)
            t.column(itemavaliablereason)
            t.column(itemnumberofsheets)
            t.column(itemdiffculty)
            t.column(iteminfoURL)
            t.column(item360URL)
            })
        if !defaults.boolForKey("dbPrep") {
            var initalItems: NSArray?
            if let path = NSBundle.mainBundle().pathForResource("initialItems", ofType: "plist") {
                initalItems = NSArray(contentsOfFile: path)
            } else {
                print("ERROR: The intital items plist is missing")
                return
            }
            var i = 0
            var currentItemUUID : String!
            var itemPlistPath : String!
            var itemPlist : NSDictionary!
            while i < initalItems!.count {
                currentItemUUID = initalItems![i] as! String
                    if itemPlistPath == NSBundle.mainBundle().pathForResource("(/currentItemUUID)", ofType: "plist") {
                        itemPlist = NSDictionary(contentsOfFile: itemPlistPath)
                        let currentItemName: String = itemPlist.valueForKey("Item Name") as! String
                        let currentItemCompany: String = itemPlist.valueForKey("Item Company") as! String
                        let currentItemBrand: String = itemPlist.valueForKey("Item Brand") as! String
                        let itemDate : NSDate = itemPlist.valueForKey("Item Release Date") as! NSDate
                        let monthFormat = NSDateFormatter()
                        monthFormat.setLocalizedDateFormatFromTemplate("MM")
                        let itemMonth = monthFormat.stringFromDate(itemDate)
                        let yearFormat =  NSDateFormatter()
                        yearFormat.setLocalizedDateFormatFromTemplate("YYYY")
                        let itemYear = yearFormat.stringFromDate(itemDate)
                        let currentItemAvaliable: Bool = itemPlist.valueForKey("Item Avaliable") as! Bool
                        let currentItemReason: String? = itemPlist.valueForKey("Item not avaliable reason") as! String?
                        let currentItemNumberOfSheets: Int64 = itemPlist.valueForKey("Number of Sheets") as! Int64
                        let currentItemDiffculty: Int64 = itemPlist.valueForKey("Assembly Diffculty") as! Int64
                        let currentItemURL: String = itemPlist.valueForKey("Instructions") as! String
                        let currentItem360: String? = itemPlist.valueForKey("Three Sixty Rotation") as! String?
                try! db.run(items.insert(uuid <- currentItemUUID, itemname <- currentItemName, itemmaker <- currentItemCompany, itembrand <- currentItemBrand, itemreleasemonth <- itemMonth, itemreleaseyear <- itemYear, itemavaliable <- currentItemAvaliable, itemavaliablereason <- currentItemReason, itemnumberofsheets <- currentItemNumberOfSheets, itemdiffculty <- currentItemDiffculty, iteminfoURL <- currentItemURL, item360URL <- currentItem360))
                i += 1
                } else if (itemPlistPath == nil) {
                    print("ERROR: plist for UUID (/currentItemUUID) is missing, will not add")
                    i += 1
                }
            }
            defaults.setBool(true, forKey: "dbPrep")
            let itemBaseRevisionNumberPath = NSBundle.mainBundle().pathForResource("Item Base Revision", ofType: "plist")
            let itemBaseRevisionNumberPlist = NSArray(contentsOfFile: itemBaseRevisionNumberPath!)
            defaults.setInteger(itemBaseRevisionNumberPlist![0] as! Int, forKey: "ItemDBUpdateRevision")
        }
            
    }
            
}
        

