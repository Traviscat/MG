//
//  ItemList.swift
//  metalgalaxy
//
//  Created by AugieD369 on 6/19/16.
//  Copyright © 2016 Aaron Erdman. All rights reserved.
//

import UIKit
import CloudKit

class ItemList: UITableViewController,UISplitViewControllerDelegate  {
    
    fileprivate var collapseDetailViewController = true
    public var theItemDb = ItemsDb()
//    var uuidList : Array<String> = []
    
    override func viewDidLoad() {
        
        splitViewController?.delegate = self
        
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        collapseDetailViewController = false
    }
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //theItemDb = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let sections = 1
        return sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rows = 1
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            
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

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItem", for: indexPath) as! ItemListCell
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let testMode = delegate.useOnlyTestData
                if testMode {
                    switch (indexPath as NSIndexPath).row {
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
                    let rowData = theItemDb.getItem((indexPath as NSIndexPath).row)
//                    print(indexPath.row)
                    cell.itemTitle.text = rowData["Item Name"]!
                    cell.itemInfo1.text = rowData["Item Maker"]!
                    cell.itemInfo2.text = rowData["Item Brand"]!
                    
/*                  //INPROGRESS: Code for Image and Color coding, likely will do as a background process after initial table cell loads.
                    let container = CKContainer.defaultContainer()
                    let privateDatabase = container.privateCloudDatabase
                    let predicate = NSPredicate(format: "uuid = %@", currentUUID)
                    let query = CKQuery(recordType: "userItemRecord", predicate: predicate)
                    privateDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
                        if error != nil {
                        println(error)
                        //TODO: Find out what error message is sent when we get a no record found and create the record here
                     } else {
                        println(results)
                        let currentUserItemRecord: CKRecord = results
                        let currentItemHas: String = currentItemUserRecord(valueForKey: "userItemHas") as! String
                        if currentItemHas.text == "Yes" {
                            cell.backgroundcolor = UIColor.greenColor()
                        }
                        else {
                            let currentItemWant: String = currentItemUserRecord(valueForKey: "userItemWant") as! String
                            if currentItemWant.text == "Yes" {
                                cell.backgroundcolor = UIColor.yellowColor()
                        }
                     }
                }
                    
*/
 
            
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


    // MARK: - Navigation

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Metal Galaxy"
        super.viewWillAppear(animated)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "loadDetail" {
            navigationItem.title = nil
            let itemNavigationController:UINavigationController = segue.destination as! UINavigationController
            let itemDetailController:ItemDetail = itemNavigationController.viewControllers[0] as! ItemDetail
            let selectedIndex = self.tableView.indexPath(for: sender as! ItemListCell)
            let theUUID = theItemDb.getItemUUID((selectedIndex?.row)!)
            itemDetailController.selectedItemUUID = theUUID["UUID"]!
        }
        
        // Pass the selected object to the new view controller.
        
    }
    

}
