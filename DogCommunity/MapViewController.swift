//
//  MapViewController.swift
//  DogCommunity
//
//  Created by Alumno on 26/04/16.
//  Copyright © 2016 TEAM PUE. All rights reserved.
//
import Parse

import UIKit

import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var dataArray:[AnyObject]?
    
    var manager = CLLocationManager()

    @IBOutlet weak var map: MKMapView!
    
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        manager.delegate = self
        
        if (manager.respondsToSelector(Selector("requestWhenInUseAuthorization"))) {
            
            manager.requestWhenInUseAuthorization()
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    //------------------------------------------------------------------------------
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 700, 700)
        
        map.setRegion(map.regionThatFits(region), animated: true)
        
        let point = MKPointAnnotation()
        
        point.coordinate = userLocation.coordinate
        
        point.title = "Current location"
                
        map.addAnnotation(point)
    }

    //------------------------------------------------------------------------------
    
    @IBAction func backToPhoto(sender: AnyObject) {
        
        self.performSegueWithIdentifier("backToPhoto", sender: dataArray)
    }
    
    @IBAction func submitAndLog(sender: AnyObject) {
        
        let user = PFUser()
        
        user.username = dataArray![2] as? String
        
        user.password = dataArray![4] as? String
        
        user.email = dataArray![3] as? String
        
        user["name"] = dataArray![0] as? String
        
        user["last_name"] = dataArray![1] as? String
        
        let imageData = UIImagePNGRepresentation(dataArray![5] as! UIImage)

        let imageFile = PFFile(name:"myProfileImage.png", data:imageData!)
        
        user["profile_picture"] = imageFile
        
        user.signUpInBackgroundWithBlock {
            
            (succeeded: Bool, error: NSError?) -> Void in
            
            if let error = error {
            
                let errorString = error.userInfo["error"] as? NSString
                
                let alertController = UIAlertController(title: "Submit failed", message: errorString as? String, preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)

            } else {
                
                self.performSegueWithIdentifier("submitAndLogin", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "backToPhoto") {
            
            let nextViewController = segue.destinationViewController as! RegisterPhotoViewController
            
            let dataArray = sender as! [AnyObject]
            
            nextViewController.dataArray = dataArray
        }
        
    }
}
