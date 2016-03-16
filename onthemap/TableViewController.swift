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
    
    var locations = [StudentObject]?()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "List of Students"
        
    }
    override func viewWillAppear(animated: Bool) {
        loadData()
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentTableCell")!
        
        let Student = locations![indexPath.row]
        let firstname = Student.first_name
        let lastname = Student.last_name
        cell.textLabel?.text = firstname! + " " + lastname!
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
        if let toOpen = locations![indexPath.row].URLlink {
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

    func loadData() {
        UdacityClient.sharedInstance().getAllStudentLocations(){ (success, locationsresponse,errorString) in
            if success {
                self.locations = locationsresponse
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
            else {
                let alertController = UIAlertController(title: "Student info Loading Failed", message: errorString?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
}
