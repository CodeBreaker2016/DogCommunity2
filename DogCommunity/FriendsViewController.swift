//
//  FriendsViewController.swift
//  DogCommunity
//
//  Created by Alumno on 02/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//
import Parse

import UIKit

class FriendsViewController: UIViewController {

    @IBOutlet weak var ProfileButton: UIButton!
    
    @IBOutlet weak var userImage: UIImageView!
    
    //--------------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let currentUser = PFUser.currentUser()

        if currentUser != nil {
            
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
        } else {
            
            let alertController = UIAlertController(title: "Warning", message: "Conexion with user lost.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "GO BACK", style: .Default, handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            self.performSegueWithIdentifier("logOut", sender: self)
        }

    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
    }
    
    //--------------------------------------------------------------------
    
}
