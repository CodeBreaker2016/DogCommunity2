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
    
    var chatUser = PFObject()
    
    //--------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        friendName!.text = (chatUser.valueForKey("name")! as! String)
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
