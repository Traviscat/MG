//
//  ItemsDb.swift
//  metalgalaxy
//
//  Created by Aaron on 7/23/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import Foundation
import SQLite

let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
let db = try! Connection("\(dbPath)/itemsdb.sqlite3")
let items = Table("items")
let uuid = Expression<String> ("uuid")
let itemname = Expression<String> ("itemname")
let itemmaker = Expression<String> ("itemmaker")
let itembrand = Expression<String> ("itembrand")
let itemcollection = Expression<String> ("itemcollection")
let itemreleasemonth = Expression<String> ("itemreleasemonth")
let itemreleaseyear = Expression<String> ("itemreleaseyear")
let itemreleaseday = Expression<String> ("itemreleaseday")
let itemavaliable = Expression<Bool> ("itemavaliable")
let itemavaliablereason = Expression<String?> ("itemavaliablereason")
let itemexclusivity = Expression<Bool> ("itemexclusivity")
let itemexclusivelocation = Expression<String?> ("itemexclusivelocation")
let itemnumberofsheets = Expression<Int> ("itemnumberofsheets")
let itemdiffculty = Expression<String> ("itemdiffculty")
let itemwebpageURL = Expression<String> ("itemwebpageURL")
let iteminfoURL = Expression<String?> ("IteminfoURL")
let item360URL = Expression<String?> ("Item360URL")
let defaults = UserDefaults.standard

open class ItemsDb {
    func startDb() {
        try! db.run(items.create(ifNotExists: true) {t in
            t.column(uuid, primaryKey: true)
            t.column(itemname, unique: true)
            t.column(itemmaker)
            t.column(itembrand)
            t.column(itemcollection)
            t.column(itemreleasemonth)
            t.column(itemreleaseyear)
            t.column(itemreleaseday)
            t.column(itemavaliable)
            t.column(itemavaliablereason)
            t.column(itemexclusivity)
            t.column(itemexclusivelocation)
            t.column(itemnumberofsheets)
            t.column(itemdiffculty)
            t.column(itemwebpageURL)
            t.column(iteminfoURL)
            t.column(item360URL)
            })
        if !defaults.bool(forKey: "dbPrep") {
            var initalItems: NSArray?
            if let path = Bundle.main.path(forResource: "initialItems", ofType: "plist") {
                initalItems = NSArray(contentsOfFile: path)
            } else {
                print("ERROR: The intital items plist is missing")
                return
            }
            var i = 0
            var currentItemUUID : String
            var itemPlist : NSDictionary!
            while i < initalItems!.count {
                currentItemUUID = initalItems![i] as! String
                let itemPlistPath = Bundle.main.path(forResource: "\(currentItemUUID)", ofType: "plist")
                if (itemPlistPath == nil) {
                    print("ERROR: plist for UUID \(currentItemUUID) is missing, will not add")
                    i += 1
                }
                else {
                        itemPlist = NSDictionary(contentsOfFile: itemPlistPath!)
                        let currentItemName: String = itemPlist["Item Name"] as! String
                    let currentItemCompany: String = itemPlist["Item Company"] as! String
                        let currentItemBrand: String = itemPlist["Item Brand"] as! String
                    let currentItemCollection: String = itemPlist["Collection"] as! String
                        let itemDate : Date = itemPlist["Item Release Date"] as! Date
                        let monthFormat = DateFormatter()
                        monthFormat.setLocalizedDateFormatFromTemplate("MM")
                        let itemMonth = monthFormat.string(from: itemDate)
                        let yearFormat =  DateFormatter()
                        yearFormat.setLocalizedDateFormatFromTemplate("YYYY")
                        let itemYear = yearFormat.string(from: itemDate)
                        let dayFormat = DateFormatter()
                        dayFormat.setLocalizedDateFormatFromTemplate("dd")
                        let itemDay = dayFormat.string(from: itemDate)
                        let currentItemAvaliable: Bool = itemPlist["Item Avaliable"] as! Bool
                        let currentItemReason: String? = itemPlist["Item not avaliable reason"] as! String?
                        let currentItemExclusivity: Bool = itemPlist["Item Exclusive"] as! Bool
                        let currentItemExclusiveLocation: String? = itemPlist["Item Exclusive To Where?"] as! String?
                        let currentItemNumberOfSheets: Int = itemPlist["Number Of Sheets"] as! Int
                        let currentItemDiffculty: String = itemPlist["Assembly Diffculty"] as! String
                        let currentItemWebURL : String = itemPlist["Models Website"] as! String
                        let currentItemInstructionsURL: String = itemPlist["Instructions"] as! String
                        let currentItem360: String? = itemPlist["Three Sixty Rotation"] as! String?
                try! db.run(items.insert(uuid <- currentItemUUID, itemname <- currentItemName, itemmaker <- currentItemCompany, itembrand <- currentItemBrand,  itemcollection <- currentItemCollection, itemreleasemonth <- itemMonth, itemreleaseyear <- itemYear, itemreleaseday <- itemDay, itemavaliable <- currentItemAvaliable, itemavaliablereason <- currentItemReason, itemexclusivity <- currentItemExclusivity, itemexclusivelocation <- currentItemExclusiveLocation, itemnumberofsheets <- currentItemNumberOfSheets, itemdiffculty <- currentItemDiffculty, itemwebpageURL <- currentItemWebURL, iteminfoURL <- currentItemInstructionsURL, item360URL <- currentItem360))
                i += 1
                }
                }
            }
            defaults.set(true, forKey: "dbPrep")
            let itemBaseRevisionNumberPath = Bundle.main.path(forResource: "Item Base Revision", ofType: "plist")
            let itemBaseRevisionNumberPlist = NSArray(contentsOfFile: itemBaseRevisionNumberPath!)
            defaults.set(itemBaseRevisionNumberPlist![0] as! Int, forKey: "ItemDBUpdateRevision")
        }
    
    func itemsAvaliable() -> Int {
        let itemCount = try! db.scalar(items.count) 
        return itemCount
    }
    func getItem(_ currentRow:Int) -> Dictionary<String, String> {
        var queryResult = [String:String]()
        let updCurrentRow = currentRow + 1
        let query = items.select(itemname, itemmaker, itembrand)
                               .order(itemname.asc)
                               .limit(1, offset: updCurrentRow)
        for row in try! db.prepare(query) {
            queryResult = ["Item Name":row[itemname], "Item Maker":row[itemmaker], "Item Brand":row[itembrand]]
        }
        return queryResult
    }
    func getItemUUID(_ selectedRow:Int) -> Dictionary<String, String> {
        var uuidQueryResult = [String:String]()
        let updCurrentRow = selectedRow + 1
        let query = items.select(uuid)
                    .order(itemname.asc)
                    .limit(1, offset: updCurrentRow)
        for row in try! db.prepare(query) {
            uuidQueryResult = ["UUID":row[uuid]]
        }
        return uuidQueryResult
    }
    func getAllUUID() -> Array<String> {
        var uuidQueryResult = [String]()
        let query = items.select(uuid)
                    .order(itemname.asc)
        for row in try! db.prepare(query) {
            uuidQueryResult.append(row[uuid])
        }
        return uuidQueryResult
    }
    
    func getItemDetail(_ selectedUuid:String) -> Dictionary<String, AnyObject?> {
        var queryResult = [String:AnyObject?]()
        let query = items.select(uuid, itemname, itemmaker, itembrand, itemcollection,itemreleasemonth, itemreleaseyear, itemreleaseday, itemavaliable, itemavaliablereason, itemexclusivity, itemexclusivelocation, itemnumberofsheets, itemdiffculty, itemwebpageURL, iteminfoURL, item360URL)
                         .filter(uuid == selectedUuid)
        for row in try! db.prepare(query) {
            queryResult = ["UUID":row[uuid]  as Optional<AnyObject>, "Item Name":row[itemname]  as Optional<AnyObject>,"Item Company":row[itemmaker]  as Optional<AnyObject>, "Item Brand":row[itembrand]  as Optional<AnyObject>, "Item Collection":row[itemcollection]  as Optional<AnyObject>, "Item Release Month":row[itemreleasemonth]  as Optional<AnyObject>, "Item Release Year":row[itemreleaseyear]  as Optional<AnyObject>, "Item Release Day":row[itemreleaseday]  as Optional<AnyObject>, "Item Avaliable":row[itemavaliable]  as Optional<AnyObject>, "Item Avaliable Reason":row[itemavaliablereason] as Optional<AnyObject>, "Item Exclusivity":row[itemexclusivity] as Optional<AnyObject>, "Item Exclusive Location":row[itemexclusivelocation] as Optional<AnyObject>, "Item Number of Sheets":row[itemnumberofsheets] as Optional<AnyObject>, "Item Diffculty":row[itemdiffculty] as Optional<AnyObject>, "Item Webpage URL":row[itemwebpageURL] as Optional<AnyObject>, "Item Instructions URL":row[iteminfoURL] as Optional<AnyObject>, "Item 360 URL":row[item360URL] as Optional<AnyObject>]
        }
    return queryResult
    }
}

