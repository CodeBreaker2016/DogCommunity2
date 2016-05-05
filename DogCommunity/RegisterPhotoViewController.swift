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
        
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            
            let alert = UIAlertController(title: "Warning", message: "Device has no camera", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let obtainedImage = dataArray![5] as? UIImage
        
        if obtainedImage != nil {
            
            self.imageView.image =  obtainedImage
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
    
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.allowsEditing = true
        
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    //------------------------------------------------------------------------
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let img = info [UIImagePickerControllerEditedImage]
        
        self.imageView.image = (img as! UIImage)
        
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
    
    @IBAction func goToNext(sender: AnyObject) {
        
        self.performSegueWithIdentifier("continueToMap", sender: dataArray)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "backToForm") {
            
            let nextViewController = segue.destinationViewController as! RegisterDataViewController
            
            let dataArray = sender as! [AnyObject]
            
            nextViewController.dataArray = dataArray
        }
        
        if (segue.identifier == "continueToMap") {
            
            let nextViewController = segue.destinationViewController as! MapViewController
            
            let dataArray = sender as! [AnyObject]
            
            nextViewController.dataArray = dataArray
        }
    }
    
}
