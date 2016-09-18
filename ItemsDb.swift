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
let defaults = NSUserDefaults.standardUserDefaults()

public class ItemsDb {
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
            var itemPlist : NSDictionary!
            while i < initalItems!.count {
                currentItemUUID = initalItems![i] as! String
                let itemPlistPath = NSBundle.mainBundle().pathForResource("\(currentItemUUID)", ofType: "plist")
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
                        let itemDate : NSDate = itemPlist["Item Release Date"] as! NSDate
                        let monthFormat = NSDateFormatter()
                        monthFormat.setLocalizedDateFormatFromTemplate("MM")
                        let itemMonth = monthFormat.stringFromDate(itemDate)
                        let yearFormat =  NSDateFormatter()
                        yearFormat.setLocalizedDateFormatFromTemplate("YYYY")
                        let itemYear = yearFormat.stringFromDate(itemDate)
                        let dayFormat = NSDateFormatter()
                        dayFormat.setLocalizedDateFormatFromTemplate("dd")
                        let itemDay = dayFormat.stringFromDate(itemDate)
                        let currentItemAvaliable: Bool = itemPlist["Item Avaliable"] as! Bool
                        let currentItemReason: String? = itemPlist["Item not avaliable reason"] as! String?
                        let currentItemExclusivity: Bool = itemPlist["Item Exclusive"] as! Bool
                        let currentItemExclusiveLocation: String? = itemPlist["Item Exclusive To Where?"] as! String?
                        let currentItemNumberOfSheets: Int = itemPlist["Number Of Sheets"] as! Int
                        let currentItemDiffculty: String = itemPlist["Assembly Diffculty"] as! String
                        let currentItemWebURL : String = itemPlist["Models Website"]
                        let currentItemInstructionsURL: String = itemPlist["Instructions"] as! String
                        let currentItem360: String? = itemPlist["Three Sixty Rotation"] as! String?
                try! db.run(items.insert(uuid <- currentItemUUID, itemname <- currentItemName, itemmaker <- currentItemCompany, itembrand <- currentItemBrand,  itemcollection <- currentItemCollection, itemreleasemonth <- itemMonth, itemreleaseyear <- itemYear, itemreleaseday <- itemDay, itemavaliable <- currentItemAvaliable, itemavaliablereason <- currentItemReason, itemexclusivity <- currentItemExclusivity, itemexclusivelocation <- currentItemExclusiveLocation, itemnumberofsheets <- currentItemNumberOfSheets, itemdiffculty <- currentItemDiffculty, itemwebpageURL <- currentItemWebURL, iteminfoURL <- currentItemInstructionsURL, item360URL <- currentItem360))
                i += 1
                }
                }
            }
            defaults.setBool(true, forKey: "dbPrep")
            let itemBaseRevisionNumberPath = NSBundle.mainBundle().pathForResource("Item Base Revision", ofType: "plist")
            let itemBaseRevisionNumberPlist = NSArray(contentsOfFile: itemBaseRevisionNumberPath!)
            defaults.setInteger(itemBaseRevisionNumberPlist![0] as! Int, forKey: "ItemDBUpdateRevision")
        }
    
    func itemsAvaliable() -> Int {
        let itemCount = try! db.scalar(items.count) 
        return itemCount
    }
    func getItem(currentRow:Int) -> Dictionary<String, String> {
        var queryResult = [String:String]()
        let updCurrentRow = currentRow + 1
        let query = items.select(uuid, itemname, itemmaker, itembrand)
                               .order(itemname.asc)
                               .limit(1, offset: updCurrentRow)
        for row in try! db.prepare(query) {
            queryResult = ["UUID":row[uuid], "Item Name":row[itemname], "Item Maker":row[itemmaker], "Item Brand":row[itembrand]]
        }
        return queryResult
    }
    func getItemDetail(selectedUuid:String) -> Dictionary<String, AnyObject?> {
        var queryResult = [String:AnyObject?]()
        let query = items.select(uuid, itemname, itemmaker, itembrand, itemreleasemonth, itemreleaseyear, itemreleaseday, itemavaliable, itemavaliablereason, itemexclusivity, itemexclusivelocation, itemnumberofsheets, itemdiffculty, itemwebpageURL, iteminfoURL, item360URL)
                         .filter(uuid == selectedUuid)
        for row in try! db.prepare(query) {
            queryResult = ["UUID":row[uuid] as! String, "Item Name":row[itemname] as! String, "Item Brand":row[itembrand] as! String, "Item Release Month":row[itemreleasemonth] as! String, "Item Release Year":row[itemreleaseyear] as! String, "Item Release Day":row[itemreleaseday] as! String, "Item Avaliable":row[itemavaliable] as! Bool, "Item Avaliable Reason":row[itemavaliablereason] as! String?, "Item Exclusivity":row[itemexclusivity] as! Bool, "Item Exclsuive Location":row[itemexclusivelocation] as! String?, "Item Number of Sheets":row[itemnumberofsheets] as! Int, "Item Diffculty":row[itemdiffculty] as! String, "Item Webpage URL":row[itemwebpageURL] as! String, "Item Instructions URL":row[iteminfoURL] as! String?, "Item 360 URL":row[item360URL] as! String?]
        }
    return queryResult
    }
}

