//
//  ViewController.swift
//  DogCommunity
//
//  Created by Alumno on 26/04/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//

import Parse

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func tryToLogUser(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(usernameField.text!, password:passwordField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("logUser", sender:self)
            } else {
                let alertController = UIAlertController(title: "Log In failed", message: "Wrong username or password", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

