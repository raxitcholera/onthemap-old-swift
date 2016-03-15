//
//  TableViewController.swift
//  onthemap
//
//  Created by raxit cholera on 12/26/15.
//  Copyright © 2015 kodeguide. All rights reserved.
//

import Foundation
import UIKit

class TableViewController:UITableViewController {
    
    var locations = [[String : AnyObject]]?()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "List of Students"
        
        var locations1 = AnyObject!()
        
        UdacityClient.sharedInstance().getAllStudentLocations(){ (success, locationsresponse,errorString) in
            if success {
                locations1 = locationsresponse! as! [String:AnyObject]
                self.locations = locations1["results"] as? [[String:AnyObject]]
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
            }
            else {
                let alertController = UIAlertController(title: nil, message: "Student info Loading Failed", preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)

                
                self.locations = self.hardCodedLocationData()
            }
        }
        
        
    }
    override func viewWillAppear(animated: Bool) {
//        self.tableView.reloadData()
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentTableCell")!
        let Student = locations![indexPath.row]
        let firstname = Student["firstName"] as? String
        let lastname = Student["lastName"] as? String
        cell.textLabel?.text = firstname! + " " + lastname!
//        cell.detailTextLabel?.text = mem["lastName"] as? String
        cell.imageView?.image =  UIImage(named: "pin")
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locations == nil {
            return 0
        } else  {
        return (locations?.count)!
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected indes %d", indexPath.row)
        let app = UIApplication.sharedApplication()
        if let toOpen = locations![indexPath.row]["mediaURL"] as? String {
            if app.canOpenURL(NSURL(string: toOpen)!){
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        print("tried to logout")
        UdacityClient.sharedInstance().performLogout { (success, errorString) -> Void in
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginController")
            
            if success {
                UIApplication.sharedApplication().keyWindow?.rootViewController = controller
            }
        }
        
    }

    
    func hardCodedLocationData() -> [[String : AnyObject]] {
        return  [
            [
                "createdAt" : "2015-02-24T22:27:14.456Z",
                "firstName" : "Jessica",
                "lastName" : "Uelmen",
                "latitude" : 28.1461248,
                "longitude" : -82.75676799999999,
                "mapString" : "Tarpon Springs, FL",
                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
                "objectId" : "kj18GEaWD8",
                "uniqueKey" : 872458750,
                "updatedAt" : "2015-03-09T22:07:09.593Z"
            ], [
                "createdAt" : "2015-02-24T22:35:30.639Z",
                "firstName" : "Gabrielle",
                "lastName" : "Miller-Messner",
                "latitude" : 35.1740471,
                "longitude" : -79.3922539,
                "mapString" : "Southern Pines, NC",
                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
                "objectId" : "8ZEuHF5uX8",
                "uniqueKey" : 2256298598,
                "updatedAt" : "2015-03-11T03:23:49.582Z"
            ], [
                "createdAt" : "2015-02-24T22:30:54.442Z",
                "firstName" : "Jason",
                "lastName" : "Schatz",
                "latitude" : 37.7617,
                "longitude" : -122.4216,
                "mapString" : "18th and Valencia, San Francisco, CA",
                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
                "objectId" : "hiz0vOTmrL",
                "uniqueKey" : 2362758535,
                "updatedAt" : "2015-03-10T17:20:31.828Z"
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z",
                "firstName" : "Jarrod",
                "lastName" : "Parkes",
                "latitude" : 34.73037,
                "longitude" : -86.58611000000001,
                "mapString" : "Huntsville, Alabama",
                "mediaURL" : "https://linkedin.com/in/jarrodparkes",
                "objectId" : "CDHfAy8sdp",
                "uniqueKey" : 996618664,
                "updatedAt" : "2015-03-13T03:37:58.389Z"
            ]
        ]
    }
    
    
}
