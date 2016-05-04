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
                
                print(self.usersList.indexOf(PFUser.currentUser()!))
                
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
        
        let userName = self.usersList[indexPath.row].objectForKey("username")!
        
        cell.textLabel!.text = String.init(userName)
        
        let details = self.usersList[indexPath.row].objectForKey("aboutUser")
        
        if details != nil {
            
            cell.detailTextLabel!.text = String.init(details!)
        } else {
            
            cell.detailTextLabel!.text = ""
        }
        
        return cell
    }
    
}
