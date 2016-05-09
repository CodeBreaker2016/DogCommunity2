//
//  AccountViewController.swift
//  DogCommunity
//
//  Created by Alumno on 02/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//
import Parse

import UIKit

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var galleryButton: UIButton!
    
    @IBOutlet weak var logOutButton: UIButton!
    //--------------------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cancelButton.hidden = true
        
        confirmButton.hidden = true
        
        galleryButton.hidden = true
        
        editButton.hidden = false
        
        logOutButton.hidden = false
        
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            
            firstNameField.text = (currentUser!.valueForKey("name") as! String)
            
            lastNameField.text = (currentUser!.valueForKey("last_name") as! String)

            usernameField.text = (currentUser!.valueForKey("username") as! String)
            
            emailField.text = (currentUser!.valueForKey("email") as! String)
                        
            let myImageFile = currentUser!["profile_picture"] as? PFFile
            
            myImageFile?.getDataInBackgroundWithBlock {
                
                (imageData: NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    if let imageData = imageData {
                        
                        let theImage = UIImage(data:imageData)
                        
                        self.userImage.image = theImage
                        
                        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
                        
                        self.userImage.clipsToBounds = true
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
        
        lastNameField.enabled = true
        
        usernameField.enabled = true
        
        emailField.enabled = true
        
        editButton.hidden = true
        
        logOutButton.hidden = true
        
        confirmButton.hidden = false
        
        cancelButton.hidden = false
        
        galleryButton.hidden = false
    }
    
    @IBAction func cancelEdit(sender: AnyObject) {
        
        firstNameField.enabled = false
        
        lastNameField.enabled = false
        
        usernameField.enabled = false

        emailField.enabled = false
        
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            
            firstNameField.text = (currentUser!.valueForKey("name") as! String)
            
            lastNameField.text = (currentUser!.valueForKey("last_name") as! String)
            
            usernameField.text = (currentUser!.valueForKey("username") as! String)
            
            emailField.text = (currentUser!.valueForKey("email") as! String)
        }
        
        editButton.hidden = false
        
        logOutButton.hidden = false
        
        confirmButton.hidden = true
        
        cancelButton.hidden = true
        
        galleryButton.hidden = true
    }
    
    @IBAction func confirmEdit(sender: AnyObject) {
        
        firstNameField.enabled = false
        
        lastNameField.enabled = false
        
        usernameField.enabled = false
        
        emailField.enabled = false
        
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            
            currentUser!.setValue(firstNameField.text, forKey: "name")

            currentUser!.setValue(lastNameField.text, forKey: "last_name")
            
            currentUser!.setValue(usernameField.text, forKey: "username")
            
            currentUser!.setValue(emailField.text, forKey: "email")
            
            let imageData = UIImagePNGRepresentation(self.userImage.image!)
            
            let imageFile = PFFile(name:"myProfileImage.png", data:imageData!)
            
            currentUser!["profile_picture"] = imageFile
            
            currentUser!.saveEventually()
        }
        
        editButton.hidden = false
        
        logOutButton.hidden = false
        
        confirmButton.hidden = true
        
        cancelButton.hidden = true
        
        galleryButton.hidden = true
    }
    
    //----------------------------------------------------------------------------
    
    @IBAction func changePhoto(sender: AnyObject) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.allowsEditing = true
        
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let img = info [UIImagePickerControllerEditedImage]
        
        self.userImage.image = (img as! UIImage)
        
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        
        self.userImage.clipsToBounds = true
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //----------------------------------------------------------------------------
    
    @IBAction func logOut(sender: AnyObject) {
        
        PFUser.logOut()
        
        self.performSegueWithIdentifier("logOutUser", sender: self)
    }
    
}
