//
//  ProfileViewController.swift
//  DogCommunity
//
//  Created by Alumno on 02/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//
import Parse

import UIKit

import Foundation

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var petsList: UITableView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    var petList = [PFObject]()
    
    let textCellIdentifier = "aPetCell"
    
    //----------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        petsList.delegate = self
        
        petsList.dataSource = self
        
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {

            let relation = currentUser!.relationForKey("petsRelation")
            
            relation.query().findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if let error = error {
                
                    print(error)
                } else {
                    print("algo se recibio")
                    
                    print(objects?.count)
                    
                    self.petList = objects!
                    
                    print(objects.debugDescription)
                }
            }

            let username = (currentUser!.valueForKey("username") as! String)
            
            usernameLabel.text = username + " pets"
            
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
    
    //----------------------------------------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return petList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = petList[indexPath.section] as? String
        
        cell.detailTextLabel?.text = petList[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
        print(petList[row])
    }

}
