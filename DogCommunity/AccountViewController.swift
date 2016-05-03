//
//  AccountViewController.swift
//  DogCommunity
//
//  Created by Alumno on 02/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//
import Parse

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var eMailField: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    //--------------------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cancelButton.hidden = true
        
        confirmButton.hidden = true
        
        editButton.hidden = false
        
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            
            firstNameField.text = (currentUser!.valueForKey("name") as! String)
            
            lastNameField.text = (currentUser!.valueForKey("last_name") as! String)
            
            eMailField.text = (currentUser!.valueForKey("email") as! String)
            
            let myImageFile = currentUser!["profile_picture"] as? PFFile
            
            myImageFile?.getDataInBackgroundWithBlock {
                
                (imageData: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    if let imageData = imageData {
                        
                        let theImage = UIImage(data:imageData)
                        
                        self.userImage.image = theImage
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    //--------------------------------------------------------------------------
    
    @IBAction func setModify(sender: AnyObject) {
        
        firstNameField.enabled = true
        
        firstNameField.borderStyle = UITextBorderStyle.Line
        
        lastNameField.enabled = true
        
        lastNameField.borderStyle = UITextBorderStyle.Line
            
        eMailField.enabled = true
        
        eMailField.borderStyle = UITextBorderStyle.Line
        
        editButton.hidden = true
        
        confirmButton.hidden = false
        
        cancelButton.hidden = false
    }
    
    @IBAction func cancelEdit(sender: AnyObject) {
        
        firstNameField.enabled = false
        
        firstNameField.borderStyle = UITextBorderStyle.None
        
        lastNameField.enabled = false
        
        lastNameField.borderStyle = UITextBorderStyle.None
        
        eMailField.enabled = false
        
        eMailField.borderStyle = UITextBorderStyle.None
        
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            
            firstNameField.text = (currentUser!.valueForKey("name") as! String)
            
            lastNameField.text = (currentUser!.valueForKey("last_name") as! String)
            
            eMailField.text = (currentUser!.valueForKey("email") as! String)
        }
        
        editButton.hidden = false
        
        confirmButton.hidden = true
        
        cancelButton.hidden = true
    }
    
    @IBAction func confirmEdit(sender: AnyObject) {
        
        firstNameField.enabled = false
        
        firstNameField.borderStyle = UITextBorderStyle.None
        
        lastNameField.enabled = false
        
        lastNameField.borderStyle = UITextBorderStyle.None
        
        eMailField.enabled = false
        
        eMailField.borderStyle = UITextBorderStyle.None
        
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            
            currentUser!.setValue(firstNameField.text, forKey: "name")

            currentUser!.setValue(lastNameField.text, forKey: "last_name")
            
            currentUser!.setValue(eMailField.text, forKey: "email")
            
            currentUser!.saveEventually()
        }
        
        editButton.hidden = false
        
        confirmButton.hidden = true
        
        cancelButton.hidden = true
    }
    
    //----------------------------------------------------------------------------
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        
        self.performSegueWithIdentifier("logOutUser", sender: self)
    }
    
}
