//
//  ItemList.swift
//  metalgalaxy
//
//  Created by AugieD369 on 6/19/16.
//  Copyright © 2016 Aaron Erdman. All rights reserved.
//

import UIKit

class ItemList: UITableViewController,UISplitViewControllerDelegate  {
    
    private var collapseDetailViewController = true
    var theItemDb = ItemsDb()
    var uuidList : Array<String> = []
    
    override func viewDidLoad() {
        
        splitViewController?.delegate = self
        
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        collapseDetailViewController = false
    }
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let sections = 1
        return sections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rows = 1
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            
            let testMode = delegate.useOnlyTestData
            if testMode {
                rows = 5
                }
            
            else {
                theItemDb.startDb()
                let possibleRows = theItemDb.itemsAvaliable()
                if possibleRows == 0 {
                    print("ERROR: No Data")
                    rows = 0
                }
                else {
                    rows = possibleRows
                }
            }
                }
     return rows
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listItem", forIndexPath: indexPath) as! ItemListCell
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let testMode = delegate.useOnlyTestData
                if testMode {
                    switch indexPath.row {
                    case 0:
                        cell.itemTitle.text = NSLocalizedString("Some Item 1", comment: "")
                    case 1:
                        cell.itemTitle.text = NSLocalizedString("Some Item 2", comment: "")
                    case 2:
                        cell.itemTitle.text = NSLocalizedString("Some Item 3", comment: "")
                    case 3:
                        cell.itemTitle.text = NSLocalizedString("Some Item 4", comment: "")
                    case 4:
                        cell.itemTitle.text = NSLocalizedString("Some Item 5", comment: "")
                    default:
                        print("ERROR: Setup bad!")
                        }
                    }
            else {
            let rowData = theItemDb.getItem(indexPath.row)
            uuidList.append(rowData["UUID"]!)
            cell.itemTitle.text = rowData["Item Name"]!
            cell.itemInfo1.text = rowData["Item Maker"]!
            cell.itemInfo2.text = rowData["Item Brand"]!
            //TODO: Add item Image and the Star/Check code
            
            
/*            let itemObject = NSDictionary(dictionary: itemsArray.itemsDict[indexPath.row]!)
            cell.itemTitle.text = itemObject["Item Name"] as? String
            cell.itemInfo1.text = itemObject["Item Company"] as? String
            if itemObject["Item Sub Brand"] as? String == "Nan" {
                cell.itemInfo2.text = nil
            }
            else {
                cell.itemInfo2.text = itemObject["Item Sub Brand"] as? String
            }
            //TEMP: Display the blank star for now, will add code for filled star later
            let starImage = UIImage(named: "listStarBlank")
            cell.image1.image = starImage
 */
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
