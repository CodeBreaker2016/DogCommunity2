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

    
    @IBOutlet weak var petsTableView: UITableView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    var petList = [PFObject]()
    
    let textCellIdentifier = "petCell"
    
    //----------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        petsTableView.delegate = self
        
        petsTableView.dataSource = self
        
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            
            let relation = currentUser!.relationForKey("petsRelation")
            
            relation.query().findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if let error = error {
                    
                    print(error)
                } else {
                    
                    self.petList = objects!
                    
                    self.petsTableView.reloadData()
                }
            }
            
            let username = (currentUser!.valueForKey("name") as! String)
            
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
        
        let tmp = petList.count
        
        return tmp
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        switch (indexPath.row) {
        
        case 0: //race
            
            cell.textLabel!.text = "Breed"
            
            let content = self.petList[indexPath.section].objectForKey("race")
            
            if content != nil {
                
                cell.detailTextLabel!.text = String.init(content!)
            } else {
                
                cell.detailTextLabel!.text = "Race not found"
            }
            break
        case 1: //color
            
            cell.textLabel!.text = "Color"
            
            let content = self.petList[indexPath.section].objectForKey("color")
            
            if content != nil {
                
                cell.detailTextLabel!.text = String.init(content!)
            } else {
                
                cell.detailTextLabel!.text = "Color not found"
            }
            break
        case 2: //description
            
            cell.textLabel!.text = "Description"
            
            let content = self.petList[indexPath.section].objectForKey("description")
            
            if content != nil {
                
                cell.detailTextLabel!.text = String.init(content!)
            } else {
                
                cell.detailTextLabel!.text = "Description not found"
            }
            break
        default: break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let name = self.petList[section].objectForKey("name")
        
        if name != nil {
            
            return String.init(name!)
        } else {
            
            return "Pet without name"
        }
        
        
    }
    
    //-----------------------------------------------------------------*
    
    @IBAction func addPet(sender: AnyObject) {
    }

}
