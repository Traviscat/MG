//
//  IPadDefaultViewController.swift
//  metalgalaxy
//
//  Created by Aaron on 6/10/17.
//  Copyright © 2017 Aaron. All rights reserved.
//

import UIKit

class IPadDefaultViewController: UIViewController {

    @IBOutlet weak var theLabel: UILabel!
    var theIndexPath:IndexPath = []


    override func viewDidLoad() {
        super.viewDidLoad()
        theLabel.text = NSLocalizedString("IPAD_DEFAULT_VIEW_MESSAGE", comment:"Please select an item to the left")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDetailViewForTableRow(indexPath:IndexPath) {
        theIndexPath = indexPath
        let itemDetailController:ItemDetail = self.storyboard?.instantiateViewController(withIdentifier: "MainRootViewController") as! ItemDetail
        let theUUID = ItemList().theItemDb.getItemUUID((theIndexPath.row))
        itemDetailController.selectedItemUUID = theUUID["UUID"]!
        self.navigationController?.pushViewController(itemDetailController, animated: true)
        
        
//        navigationController?.performSegue(withIdentifier: "loadDetail", sender: nil)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "loadDetail" {
            //            if UIDevice.current.userInterfaceIdiom == .phone {
            //                navigationItem.title = nil
            //            }
            let itemNavigationController:UINavigationController = segue.destination as! UINavigationController
            let itemDetailController:ItemDetail = itemNavigationController.viewControllers[0] as! ItemDetail
                let theUUID = ItemList().theItemDb.getItemUUID((theIndexPath.row))
                itemDetailController.selectedItemUUID = theUUID["UUID"]!
            }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
