//
//  TargetTableViewController.swift
//  hackbu17ipapp
//
//  Created by Charles DiGiovanna on 2/26/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit
import SwiftyJSON

class TargetTableViewController: UITableViewController {
    var data = [User]()
    var alertTextField: UITextField?
    var fileKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        loadUsers() {
            self.tableView.reloadData()
        }
        configureNib()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Testing
    
    func createFakeData() {
        data.append(User(id: "1782217822", name: "Charlie DiGi", username: "cd17822", score: 17))
        data.append(User(id: "1782217823", name: "Tyler Schmitt", username: "schmittj", score: 8))
        data.append(User(id: "1782217824", name: "Annika Wiesinger", username: "aaw", score: 2))
    }
    
    // MARK: - Personal
    
    func loadUsers(_ callback: @escaping (Void) -> Void) {
//        GET("/users?ofUser=\(USER!.id)", callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
//            if err != nil {
//                showError(on: self)
//            } else if res != nil {
//                for user in res!["users"].arrayValue {
//                    //                    data.append()
//                }
//                
//                //                data = res!["users"].arrayValue.map {  }
//                
//                callback()
//            }
//        })
        createFakeData()
    }
    
    func textFieldHandler(textField: UITextField!) {
        textField.placeholder = "Username"
        textField.text = ""
        self.alertTextField = textField
    }
    
    // MARK: - Table view data source
    
    func configureNib() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let user = data[(indexPath as NSIndexPath).row]
        cell.label1.text = user.name
        cell.label2.text = "\(user.score)"
        cell.label3.text = ""
        cell.iconImageView.image = #imageLiteral(resourceName: "sword")
        cell.iconbg.backgroundColor = colors[(indexPath as NSIndexPath).row % 6]
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // THIS CALL BELOW WILL BE IN THE CALLBACK OF ME GETTING THE DATA FROM ANNIKAS VIDLINK
        // OR VIDLINK WILL BE POSTED IN THE PRIOR VC, WAITED FOR, SENT
        POST("/registerFire", parameters: ["shooter": USER!.id,
                                           "shootee": data[(indexPath as NSIndexPath).row].id,
                                           "link": self.fileKey!], callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
                                            if err != nil {
                                                showError(on: self)
                                            }else{
                                                self.dismiss(animated: true, completion: nil)
                                            }
        })
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "GroupsToGroupUsers" {
//            let vc = segue.destination as! UserViewController
//            
//            vc.group = sender as? Group
//            vc.user = sender as? User
//        }
//    }
}
