//
//  NewPetViewController.swift
//  DogCommunity
//
//  Created by Alumno on 03/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//

import Parse

import UIKit

class NewPetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var petImage: UIImageView!
    
    @IBOutlet weak var petNameField: UITextField!
    
    @IBOutlet weak var petRaceField: UITextField!
    
    @IBOutlet weak var petColorField: UITextField!
    
    @IBOutlet weak var petDescriptionField: UITextField!
    
    //----------------------------------------------------------------

    override func viewDidLoad() {

        super.viewDidLoad()
        
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            
            let alert = UIAlertController(title: "Warning", message: "Device has no camera", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    //-----------------------------------------------------------------
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let img = info [UIImagePickerControllerEditedImage]
        
        self.petImage.image = (img as! UIImage)
        
        self.petImage.layer.cornerRadius = self.petImage.frame.size.width / 2
        
        self.petImage.clipsToBounds = true
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //-----------------------------------------------------------------
    
    @IBAction func confirmCreation(sender: AnyObject) {
        
        let newPet = PFObject(className:"Pets")
        
        newPet["name"] = petNameField.text!
        
        newPet["race"] = petRaceField.text!
        
        newPet["color"] = petColorField.text!
        
        newPet["description"] = petDescriptionField.text!
        
        let imageData = UIImagePNGRepresentation(self.petImage.image!)
        
        let imageFile = PFFile(name:"petPicture.png", data:imageData!)
        
        newPet["profile_picture"] = imageFile
        
        newPet.saveInBackgroundWithBlock {
            
            (success: Bool, error: NSError?) -> Void in
            
            if (success) {
                
                let relation : PFRelation = PFUser.currentUser()!.relationForKey("petsRelation")
                
                relation.addObject(newPet)
                
                PFUser.currentUser()!.saveEventually()
            
                self.performSegueWithIdentifier("confirmPet", sender: self)
            } else {
                
                let alert = UIAlertController(title: "Submit Failed", message: "Check your connection and try again", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                
                alert.addAction(okAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func selectPetPhoto(sender: AnyObject) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.allowsEditing = true
        
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
}
