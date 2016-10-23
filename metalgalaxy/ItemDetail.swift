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
        ItemList().theItemDb.startDb()
        itemDetailsTable = ItemList().theItemDb.getItemDetail(selectedItemUUID)
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 3
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if (indexPath as NSIndexPath).section == 0 {
        switch (indexPath as NSIndexPath).row {
        case 0:
            theCompanyCell.detailTextLabel!.text = itemDetailsTable["Item Company"] as? String
        case 1:
            theBrandCell.detailTextLabel!.text = itemDetailsTable["Item Brand"] as? String
        case 2:
            theCollectionCell.detailTextLabel!.text = itemDetailsTable["Item Collection"] as? String
        case 3:
            let userCalendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.year = (itemDetailsTable["Item Release Year"] as? Int)!
            dateComponents.month = (itemDetailsTable["Item Release Month"] as? Int)!
            dateComponents.day = (itemDetailsTable["Item Release Day"] as? Int)!
            let fullDate = userCalendar.date(from: dateComponents)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            theReleaseDateCell.detailTextLabel!.text = dateFormatter.string(from: fullDate!)
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
                switch (indexPath as NSIndexPath).row {
                case 0:
                    if (itemDetailsTable["Item Webpage URL"] == nil) {
                        theWebSiteCell.textLabel!.text = "Item Web Page (Not Avaliable)"
                        theWebSiteCell.isUserInteractionEnabled = false
                        theWebSiteCell.accessoryType = UITableViewCellAccessoryType.none
                    } else {
                        selectedInfoURL = URL(fileURLWithPath: itemDetailsTable["Item Webpage URL"] as! String)
                    }
                case 1:
                    if (itemDetailsTable["Item Instructions URL"] == nil) {
                        theInstructionsCell.textLabel!.text = "Assembly Instructions (Not Avaliable)"
                        theInstructionsCell.isUserInteractionEnabled = false
                        theInstructionsCell.accessoryType = UITableViewCellAccessoryType.none
                    } else {
                        selectedInstructionsURL = URL(fileURLWithPath: itemDetailsTable["Item Instructions URL"] as! String)
                    }
                case 2:
                    if (itemDetailsTable["Item 360 URL"] == nil) {
                        the360Cell.textLabel!.text = "360 View (Not Avaliable)"
                        the360Cell.isUserInteractionEnabled = false
                        the360Cell.accessoryType = UITableViewCellAccessoryType.none
                    } else {
                        selected360URL = URL(fileURLWithPath: itemDetailsTable["Item Instructions URL"] as! String)
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            switch (indexPath as NSIndexPath).row {
            case 0:
                let safariViewController : SFSafariViewController = SFSafariViewController(url: selectedInfoURL!)
                self.show(safariViewController, sender: nil)
            case 1:
                let safariViewController : SFSafariViewController = SFSafariViewController(url: selectedInstructionsURL!)
                self.show(safariViewController, sender: nil)
            case 2:
                let safariViewController : SFSafariViewController = SFSafariViewController(url: selected360URL!)
                self.show(safariViewController, sender: nil)
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
