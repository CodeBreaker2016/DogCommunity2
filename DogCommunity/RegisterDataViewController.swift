//
//  RegisterDataViewController.swift
//  DogCommunity
//
//  Created by Alumno on 02/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//

import Parse

import UIKit

import Foundation

class RegisterDataViewController: UIViewController {
    
    var dataArray:[AnyObject] = ["","","","","",UIImage()]

    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var confirmMailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameField.text = (dataArray[0] as! String)
        lastNameField.text = (dataArray[1] as! String)
        usernameField.text = (dataArray[2] as! String)
        emailField.text = (dataArray[3] as! String)
        confirmMailField.text = (dataArray[3] as! String)
        passwordField.text = (dataArray[4] as! String)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func contnueRegister(sender: AnyObject) {
        
        dataArray[0] = firstNameField.text!
        dataArray[1] = lastNameField.text!
        dataArray[2] = usernameField.text!
        dataArray[3] = emailField.text!
        dataArray[4] = passwordField.text!
        
        self.performSegueWithIdentifier("continueToPhoto", sender: dataArray)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "continueToPhoto") {
        
            let nextViewController = segue.destinationViewController as! RegisterPhotoViewController
            
            let dataArray = sender as! [AnyObject]
            
            nextViewController.dataArray = dataArray
        }
    }

}
