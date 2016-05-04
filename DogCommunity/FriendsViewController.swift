//
//  FriendsViewController.swift
//  DogCommunity
//
//  Created by Alumno on 02/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//
import Parse

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var ProfileButton: UIButton!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var friendsList = [PFObject]()
    
    let textCellIdentifier = "friendCell"

    //--------------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let currentUser = PFUser.currentUser()
        
        friendsTableView.delegate = self
        
        friendsTableView.dataSource = self

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
            
            let relation = currentUser!.relationForKey("friendsRelation")
            
            relation.query().findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if let error = error {
                    
                    print(error)
                } else {
                    
                    self.friendsList = objects!
                    
                    self.friendsTableView.reloadData()
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tmp = friendsList.count
        
        return tmp
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        let userName = self.friendsList[indexPath.row].objectForKey("username")!
        
        cell.textLabel!.text = String.init(userName)
        
        let details = self.friendsList[indexPath.row].objectForKey("aboutUser")
        
        if details != nil {
            
            cell.detailTextLabel!.text = String.init(details!)
        } else {
            
            cell.detailTextLabel!.text = ""
        }
        
        return cell
    }
}
