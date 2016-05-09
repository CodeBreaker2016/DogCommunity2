//
//  ChatViewController.swift
//  DogCommunity
//
//  Created by Alumno on 04/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//
import Parse

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var friendName: UILabel!
    
    @IBOutlet weak var friendImage: UIImageView!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    var chatUser: PFUser?
    
    //--------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        chatTableView.delegate = self
        
        chatTableView.dataSource = self
        
        let userName = chatUser!.valueForKey("name")!
        
        friendName.text = String.init(userName)
        
        let friendImg = chatUser!.objectForKey("profile_picture") as? PFFile
        
        friendImg?.getDataInBackgroundWithBlock {
            
            (imageData: NSData?, error: NSError?) -> Void in
            
            if error == nil {
                
                if let imageData = imageData {
                    
                    let theImage = UIImage(data:imageData)
                    
                    self.friendImage!.image = theImage
                    
                    self.friendImage!.layer.cornerRadius = (self.friendImage!.frame.size.width / 2)
                    
                    self.friendImage!.clipsToBounds = true
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    //--------------------------------------------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tmp = 1
        
        return tmp
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)
                
        return cell
    }
}
