//
//  RegisterPhotoViewController.swift
//  DogCommunity
//
//  Created by Alumno on 02/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//
import Parse

import UIKit

class RegisterPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var dataArray:[AnyObject]?
    
    @IBOutlet weak var imageView: UIImageView!
    
    /*
    first
    last
    user
    email
    password
    */
    
    //------------------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let obtainedImage = dataArray![5] as? UIImage
        
        if obtainedImage != nil{
            
            self.imageView.image =  obtainedImage
            
            self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
            
            self.imageView.clipsToBounds = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------------------------
    
    @IBAction func galleryPhoto(sender: AnyObject) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.allowsEditing = true
        
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func cameraPhoto(sender: AnyObject) {
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            
            picker.allowsEditing = true
            
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            
            self.presentViewController(picker, animated: true, completion: nil)
        } else {
            
            let alert = UIAlertController(title: "Warning", message: "Device has no camera", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //------------------------------------------------------------------------
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let img = info [UIImagePickerControllerEditedImage]
        
        self.imageView.image = (img as! UIImage)
        
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        
        self.imageView.clipsToBounds = true
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        dataArray![5] = (img as! UIImage)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //------------------------------------------------------------------------
    
    @IBAction func backToForm(sender: AnyObject) {
        
        self.performSegueWithIdentifier("backToForm", sender: dataArray)
    }
    
    @IBAction func goToNext(sender: AnyObject) { //now submit
        
        let user = PFUser()
        
        user.username = dataArray![2] as? String
        
        user.password = dataArray![4] as? String
        
        user.email = dataArray![3] as? String
        
        user["name"] = dataArray![0] as? String
        
        user["last_name"] = dataArray![1] as? String
        
        let imageData = UIImagePNGRepresentation(dataArray![5] as! UIImage)
        
        let imageFile = PFFile(name:"myProfileImage.png", data:imageData!)
        
        user["profile_picture"] = imageFile
        
        user.signUpInBackgroundWithBlock {
            
            (succeeded: Bool, error: NSError?) -> Void in
            
            if let error = error {
                
                let errorString = error.userInfo["Error"] as? NSString
                
                let alertController = UIAlertController(title: "Submit failed", message: errorString as? String, preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                
                self.performSegueWithIdentifier("submitAndLogin", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "backToForm") {
            
            let nextViewController = segue.destinationViewController as! RegisterDataViewController
            
            let dataArray = sender as! [AnyObject]
            
            nextViewController.dataArray = dataArray
        }
    }
    
}
