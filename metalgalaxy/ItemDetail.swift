//
//  ItemDetail.swift
//  metalgalaxy
//
//  Created by AugieD369 on 6/19/16.
//  Copyright © 2016 Aaron Erdman. All rights reserved.
//

import UIKit
import SafariServices

class ItemDetail: UITableViewController {
    var selectedItemUUID:String = ""
    let selectedItemName:String = ""
    var selectedInfoURL:URL? = nil
    var selectedInstructionsURL:URL? = nil
    var selected360URL:URL? = nil
    var itemDetailsTable:Dictionary <String, AnyObject?> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemList().theItemDb.startDb()
        if selectedItemUUID == "" {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let theUUID = ItemList().theItemDb.getItemUUID(0)
                selectedItemUUID = theUUID["UUID"]!
            } else {
                print("UUID is nil, app may crash if this is not fixed")
            }
        }
        itemDetailsTable = ItemList().theItemDb.getItemDetail(selectedItemUUID)
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        //self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = selectedItemName
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func encodeRestorableState(with coder: NSCoder) {
        //1
        let restoreUUID = selectedItemUUID
        coder.encode(restoreUUID, forKey: "uuid")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        selectedItemUUID = coder.decodeObject(forKey: "uuid") as! String
        super.decodeRestorableState(with: coder)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 11
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        if (indexPath as NSIndexPath).row >= 0 && (indexPath as NSIndexPath).row < 8 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Main", for: indexPath) as! DetailMainCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "Link", for: indexPath) as! DetailLinkCell
        }
        switch (indexPath as NSIndexPath).row {
        case 0:
            cell!.textLabel!.text = "Company:"
            cell!.detailTextLabel!.text = itemDetailsTable["Item Company"] as? String
        case 1:
            cell!.textLabel!.text = "Brand:"
            cell!.detailTextLabel!.text = itemDetailsTable["Item Brand"] as? String
        case 2:
            cell!.textLabel!.text = "Collection:"
            cell!.detailTextLabel!.text = itemDetailsTable["Item Collection"] as? String
        case 3:
            cell!.textLabel!.text = "Release Date:"
            let userCalendar = Calendar.current
            var dateComponents = DateComponents()
            let theYear:String = (itemDetailsTable["Item Release Year"] as? String)!
            let theMonth:String = (itemDetailsTable["Item Release Month"] as? String)!
            let theDay:String = (itemDetailsTable["Item Release Day"] as? String)!
            dateComponents.year = Int(theYear)
            dateComponents.month = Int(theMonth)
            dateComponents.day = Int(theDay)
            let fullDate = userCalendar.date(from: dateComponents)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            cell!.detailTextLabel!.text = dateFormatter.string(from: fullDate!)
        case 4:
            cell!.textLabel!.text = "Item Avaliable Status:"
            let theItemAvaliableStatus: Bool = (itemDetailsTable["Item Avaliable"] as? Bool)!
            if !theItemAvaliableStatus
            {
                cell!.detailTextLabel!.text = itemDetailsTable["Item Avaliable Reason"] as? String
            } else {
                cell!.detailTextLabel!.text = "Avaliable Now"
            }
        case 5:
            cell!.textLabel!.text = "Item Exclusivity:"
            let theItemExclusivityStatus: Bool = (itemDetailsTable["Item Exclusivity"] as? Bool)!
            if theItemExclusivityStatus {
                cell!.detailTextLabel!.text = itemDetailsTable["Item Exclusive Location"] as? String
            } else {
                cell!.detailTextLabel!.text = "None"
            }
        case 6:
            cell!.textLabel!.text = "Assembly Diffculty:"
            cell!.detailTextLabel!.text = itemDetailsTable["Item Diffculty"] as? String
        case 7:
            cell!.textLabel!.text = "Number of Sheets:"
            let sheetNumber = itemDetailsTable["Item Number of Sheets"] as? Int
            let sheetNumberString = String(describing: sheetNumber!)
            cell!.detailTextLabel!.text = sheetNumberString

                case 8:
                    if (itemDetailsTable["Item Webpage URL"] == nil) {
                        cell!.textLabel!.text = "Item Web Page (Not Avaliable)"
                        cell!.isUserInteractionEnabled = false
                        cell!.accessoryType = UITableViewCellAccessoryType.none
                    } else {
                        cell!.textLabel!.text = "Item Web Page"
                        selectedInfoURL = URL(string: itemDetailsTable["Item Webpage URL"] as! String)
                    }
                case 9:
                    if (itemDetailsTable["Item Instructions URL"] == nil) {
                        cell!.textLabel!.text = "Assembly Instructions (Not Avaliable)"
                        cell!.isUserInteractionEnabled = false
                        cell!.accessoryType = UITableViewCellAccessoryType.none
                    } else {
                        cell!.textLabel!.text = "Assembly Instructions"
                        selectedInstructionsURL = URL(string: itemDetailsTable["Item Instructions URL"] as! String)
                    }
                case 10:
                    if (itemDetailsTable["Item 360 URL"] == nil) {
                        cell!.textLabel!.text = "360 View (Not Avaliable)"
                        cell!.isUserInteractionEnabled = false
                        cell!.accessoryType = UITableViewCellAccessoryType.none
                    } else {
                        cell!.textLabel!.text = "360 View"
                        selected360URL = URL(string: itemDetailsTable["Item 360 URL"] as! String)
                    }
                default:
                    break
                }
        return cell!
        }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch (indexPath as NSIndexPath).row {
            case 8:
                let safariViewController = SFSafariViewController(url: selectedInfoURL!)
                safariViewController.modalPresentationStyle = .overFullScreen
                self.present(safariViewController, animated: true, completion: nil)
            case 9:
                let safariViewController : SFSafariViewController = SFSafariViewController(url: selectedInstructionsURL!)
                safariViewController.modalPresentationStyle = .overFullScreen
                self.present(safariViewController, animated: true, completion: nil)

            case 10:
                let safariViewController : SFSafariViewController = SFSafariViewController(url: selected360URL!)
                safariViewController.modalPresentationStyle = .overFullScreen
                self.present(safariViewController, animated: true, completion: nil)
            default:
                print("Cell tapped does not have an action tied to it")
            }
    }
    
     
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
    

}
