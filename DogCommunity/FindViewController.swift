//
//  FindViewController.swift
//  DogCommunity
//
//  Created by Alumno on 03/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//

import Parse

import UIKit

class FindViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!

    
    
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
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    
}
