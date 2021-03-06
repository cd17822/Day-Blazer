//
//  GroupsTableViewController.swift
//  hackbu17ipapp
//
//  Created by Charles DiGiovanna on 2/25/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit
import SwiftyJSON

class GroupsTableViewController: UITableViewController {
    var data = [Group]()
    var alertTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        createFakeData() // FOR TESTING ONLY
        loadGroups() {
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
        data.append(Group(id: "1782217822", name: "Day Blazers"))
        data.append(Group(id: "1782217823", name: "Women in Tech"))
        data.append(Group(id: "1782217824", name: "Imagine I had"))
        data.append(Group(id: "1782217825", name: "This many friends"))
    }

    // MARK: - Personal

    func loadGroups(_ callback: @escaping (Void) -> Void) {
//        GET("/groups", callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
//            if err != nil {
//                showError(on: self)
//            } else if res != nil {
//                for group in res!["groups"].arrayValue {
////                    data.append()
//                }
//                
////                data = res!["groups"].arrayValue.map {  }
//                
//                callback()
//            }
//        })
    }
    
    func configureNib() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    
    @IBAction func camTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addGroupTapped(_ sender: Any) {
        let alert = UIAlertController(title: "New Group", message: "Enter the name of the group you'd like to create.", preferredStyle:
            UIAlertControllerStyle.alert)
        alert.view.tintColor = UIColor.red
        
        alert.addTextField(configurationHandler: textFieldHandler)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            self.addGroup(withName: self.alertTextField!.text!)
        }))
        
        self.present(alert, animated: true, completion:nil)
    }
    
    func textFieldHandler(textField: UITextField!) {
        textField.placeholder = "Group Name"
        textField.text = ""
        self.alertTextField = textField
    }
    
    func addGroup(withName groupName: String) {
        POST("/createTeam", parameters: ["groupName":groupName],
             callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
                if err != nil {
                    showError(on: self)
                }
                
                self.loadGroups(){}
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell

        let group = data[(indexPath as NSIndexPath).row]
        cell.label1.text = ""
        cell.label2.text = ""
        cell.label3.text = group.name
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
        performSegue(withIdentifier: "GroupsToGroupUsers", sender: data[(indexPath as NSIndexPath).row])
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GroupsToGroupUsers" {
            let vc = segue.destination as! GroupUsersTableViewController
            
            vc.group = sender as? Group
        }
    }

}
