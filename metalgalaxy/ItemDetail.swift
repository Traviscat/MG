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
    let selectedItemUUID:String = ""
    let selectedItemName:String = ""
    var selectedInfoURL:NSURL = NSURL()
    var selectedInstructionsURL = NSURL()
    var selected360URL = NSURL()
    let itemDetailsTable:Dictionary <String, AnyObject?> = [:]
    @IBOutlet weak var theCompanyCell: UITableViewCell!
    @IBOutlet weak var theBrandCell: UITableViewCell!
    @IBOutlet weak var theCollectionCell: UITableViewCell!
    @IBOutlet weak var theReleaseDateCell: UITableViewCell!
    @IBOutlet weak var theItemAvaliableCell: UITableViewCell!
    @IBOutlet weak var theItemExclusivityCell: UITableViewCell!
    @IBOutlet weak var theAssemblyDiffcultyCell: UITableViewCell!
    @IBOutlet weak var theNumberOfSheetsCell: UITableViewCell!
    @IBOutlet weak var theWebSiteCell: UITableViewCell!
    @IBOutlet weak var theInstructionsCell: UITableViewCell!
    @IBOutlet weak var the360Cell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        if itemList.theItemsDb == nil {
            itemList.theItemsDb.startDb()
        }
        itemDetailsTable = itemList.theItemsDb.getItemDetail(selectedUuid:selectedItemUUID)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        navigationItem.title = selectedItemName
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 3
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        if indexPath.section == 0 {
        switch indexPath.row {
        case 0:
            theCompanyCell.detailTextLabel!.text = itemDetailsTable["Item Company"] as? String
        case 1:
            theBrandCell.detailTextLabel!.text = itemDetailsTable["Item Brand"] as? String
        case 2:
            theCollectionCell.detailTextLabel!.text = itemDetailsTable["Item Collection"] as? String
        case 3:
            let userCalendar = NSCalendar.currentCalendar()
            let dateComponents = NSDateComponents()
            dateComponents.year = (itemDetailsTable["Item Release Year"] as? Int)!
            dateComponents.month = (itemDetailsTable["Item Release Month"] as? Int)!
            dateComponents.day = (itemDetailsTable["Item Release Day"] as? Int)!
            let fullDate = userCalendar.dateFromComponents(dateComponents)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            theReleaseDateCell.detailTextLabel!.text = dateFormatter.stringFromDate(fullDate!)
        case 4:
            let theItemAvaliableStatus: Bool = (itemDetailsTable["Item Avaliable"] as? Bool)!
            if !theItemAvaliableStatus
            {
                theItemAvaliableCell.detailTextLabel!.text = itemDetailsTable["Item Avaliable Reason"] as? String
            } else {
                theItemAvaliableCell.detailTextLabel!.text = "Avaliable Now" 
            }
        case 5:
            let theItemExclusivityStatus: Bool = (itemDetailsTable["Item Exclusivity"] as? Bool)!
            if !theItemExclusivityStatus {
                theItemExclusivityCell.detailTextLabel!.text = itemDetailsTable["Item Exclusive Location"] as? String
            } else {
                theItemExclusivityCell.detailTextLabel!.text = "None"
            }
        case 6:
            theAssemblyDiffcultyCell.detailTextLabel!.text = itemDetailsTable["Assembly Diffculty"] as? String
        case 7:
            theNumberOfSheetsCell.detailTextLabel!.text = itemDetailsTable["Number of Sheets"] as? String
        default:
           break
            }
        } else {
                switch indexPath.row {
                case 0:
                    if (itemDetailsTable["Item Webpage URL"] == nil) {
                        theWebSiteCell.textLabel!.text = "Item Web Page (Not Avaliable)"
                        theWebSiteCell.userInteractionEnabled = false
                        theWebSiteCell.accessoryType = UITableViewCellAccessoryType.None
                    } else {
                        selectedInfoURL = NSURL(fileURLWithPath: itemDetailsTable["Item Webpage URL"] as! String)
                    }
                case 1:
                    if (itemDetailsTable["Item Instructions URL"] == nil) {
                        theInstructionsCell.textLabel!.text = "Assembly Instructions (Not Avaliable)"
                        theInstructionsCell.userInteractionEnabled = false
                        theInstructionsCell.accessoryType = UITableViewCellAccessoryType.None
                    } else {
                        selectedInstructionsURL = NSURL(fileURLWithPath: itemDetailsTable["Item Instructions URL"] as! String)
                    }
                case 2:
                    if (itemDetailsTable["Item 360 URL"] == nil) {
                        the360Cell.textLabel!.text = "360 View (Not Avaliable)"
                        the360Cell.userInteractionEnabled = false
                        the360Cell.accessoryType = UITableViewCellAccessoryType.None
                    } else {
                        selected360URL = NSURL(fileURLWithPath: itemDetailsTable["Item Instructions URL"] as! String)
                    }
                default:
                   break
                }
            }
        return cell
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let safariViewController : SFSafariViewController = SFSafariViewController(URL: selectedInfoURL)
                self.showViewController(safariViewController, sender: nil)
            case 1:
                let safariViewController : SFSafariViewController = SFSafariViewController(URL: selectedInstructionsURL)
                self.showViewController(safariViewController, sender: nil)
            case 2:
                let safariViewController : SFSafariViewController = SFSafariViewController(URL: selected360URL)
                self.showViewController(safariViewController, sender: nil)
            default:
                break
            }
        } else {
            print("Cell tapped does not have an action tied to it")
        }
    }
    
     
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
    

}
