//
//  FriendsViewController.swift
//  DogCommunity
//
//  Created by Alumno on 02/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//

import Parse

import UIKit

import Foundation

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    var friendsList = [PFObject]()
    
    var chatUser = PFObject()
    
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
                        
                        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
                        
                        self.userImage.clipsToBounds = true
                    }
                }
            }
            
            let relation = currentUser!.relationForKey("friends")
            
            relation.query().findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if let error = error {
                    
                    print(error)
                } else {
                    
                    self.friendsList = objects!
                    
                    self.friendsTableView.reloadData()
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
        let tmp = friendsList.count
        
        return tmp
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        let userName = self.friendsList[indexPath.row].valueForKey("username")!
        
        cell.textLabel!.text = String.init(userName)
        
        let friendImage = self.friendsList[indexPath.row].objectForKey("profile_picture") as? PFFile
        
        friendImage?.getDataInBackgroundWithBlock {
            
            (imageData: NSData?, error: NSError?) -> Void in
            
            if error == nil {
                
                if let imageData = imageData {
                    
                    let theImage = UIImage(data:imageData)
                    
                    cell.imageView?.image = theImage
                }
            }
        }
        
        let details = self.friendsList[indexPath.row].valueForKey("aboutUser")
        
        if details != nil {
            
            cell.detailTextLabel!.text = String.init(details!)
        } else {
            
            cell.detailTextLabel!.text = ""
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let friend = self.friendsList[indexPath.row]
        
        chatUser = friend
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("goChat", sender: chatUser)

    }

    //----------------------------------------------------------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "goChat") {
            
            let nextViewController = segue.destinationViewController as! ChatViewController
            
            let chatUser = sender as! PFObject
            
            nextViewController.chatUser = chatUser
        }
    }
    
}
