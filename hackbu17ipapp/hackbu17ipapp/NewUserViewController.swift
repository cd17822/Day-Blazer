//
//  NewUserViewController.swift
//  hackbu17ipapp
//
//  Created by Charles DiGiovanna on 2/26/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewUserViewController: UIViewController {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createTapped(_ sender: Any) {
        if usernameField.text! != "" &&
            nameField.text != "" &&
            passwordField.text != "" {
            
            POST("/users", parameters: ["name": "Becky Hammond",
                                        "username": "bbgirl123",
                                        "password": "bbgirl123"],
                 callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
                    if err != nil {
                        showError(on: self)
                    }else{
                        // TODOOOOOOOOO
                        USER = User(id: "", name: "", username: "", score: 0)
                        self.dismiss(animated: true, completion: nil)
                    }
            })
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
