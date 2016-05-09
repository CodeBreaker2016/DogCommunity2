//
//  FindViewController.swift
//  DogCommunity
//
//  Created by Alumno on 03/05/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//

import Parse

import UIKit

import MapKit

import Foundation

class FindViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var manager = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var usersTableView: UITableView!
    
    var usersList = [PFObject]()
    
    let textCellIdentifier = "userCell"
    
    //--------------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        usersTableView.delegate = self
        
        usersTableView.dataSource = self
        
        let query : PFQuery = PFUser.query()!
        
        query.whereKey("username", notEqualTo: PFUser.currentUser()!.valueForKey("username")!)
        
        query.findObjectsInBackgroundWithBlock {
            
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
            
                self.usersList = objects!
                
                self.usersTableView.reloadData()
            }
        }
        
        map.delegate = self
        
        manager.delegate = self
        
        if (manager.respondsToSelector(Selector("requestWhenInUseAuthorization"))) {
            
            manager.requestWhenInUseAuthorization()
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    //-------------------------------------------------------------------
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 700, 700)
        
        map.setRegion(map.regionThatFits(region), animated: true)
        
        let point = MKPointAnnotation()
        
        point.coordinate = userLocation.coordinate
        
        point.title = "Current location"
        
        map.addAnnotation(point)
    }
    
    //-------------------------------------------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tmp = usersList.count
        
        return tmp
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        let userName = self.usersList[indexPath.row].valueForKey("name")!
        
        cell.textLabel!.text = String.init(userName)
        
        let friendImage = self.usersList[indexPath.row].objectForKey("profile_picture") as? PFFile
        
        friendImage?.getDataInBackgroundWithBlock {
            
            (imageData: NSData?, error: NSError?) -> Void in
            
            if error == nil {
                
                if let imageData = imageData {
                    
                    let theImage = UIImage(data:imageData)
                    
                    cell.imageView!.image = theImage
                    
                    cell.imageView!.layer.cornerRadius = cell.imageView!.frame.size.height / 2
                    
                    cell.imageView!.clipsToBounds = true
                }
            }
        }
        
        let details = self.usersList[indexPath.row].valueForKey("aboutUser")
        
        if details != nil {
            
            cell.detailTextLabel!.text = String.init(details!)
        } else {
            
            cell.detailTextLabel!.text = ""
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let msg = self.usersList[indexPath.row].valueForKey("name")!
        
        let alertController = UIAlertController(title: "User selected", message: String.init(msg), preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            let relation : PFRelation = PFUser.currentUser()!.relationForKey("friends")
            
            relation.addObject(self.usersList[indexPath.row])
            
            PFUser.currentUser()!.saveEventually()
            
            
            
            let query : PFQuery = PFUser.query()!
            
            query.whereKey("username", equalTo: String.init(self.usersList[indexPath.row].valueForKey("username")!))
            
            query.findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    print(objects![0].debugDescription)
                    
                    let relation2 : PFRelation = objects![0].relationForKey("friends")
                    
                    relation2.addObject(PFUser.currentUser()!)
                    
                    objects?[0].setObject(relation2, forKey: "friends")
                }
            }
            
            
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        alertController.addAction(confirmAction)
        
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
