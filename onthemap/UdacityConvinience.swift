//
//  UdacityConvinience.swift
//  onthemap
//
//  Created by raxit cholera on 12/23/15.
//  Copyright © 2015 kodeguide. All rights reserved.
//

import Foundation
import UIKit


extension UdacityClient {
    func authenticateWithViewController(hostViewController: LoginController, completionHandler: (success: Bool, errorString: NSError?) -> Void) {
        
        self.findSessionId(hostViewController.userNameTextBox.text, password:hostViewController.passwordTextBox.text) { (success, error) in
            if success {
                    completionHandler(success: true, errorString: nil)
            }
            else {
                completionHandler(success: success, errorString: error)
            }
            
        }
        
        
    }
    
    func findSessionId(userName:String!, password:String!,completionHandler: (success: Bool, errorString: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        let internalDict = ["username" : userName,"password":password]
        let jsonBody = ["udacity" :internalDict]
        
        taskForPOSTMethod(Methods.UdacitySession, base: "Udacity", parameters: parameters, jsonBody: jsonBody) { (result, error) -> Void in
            
            
            if error != nil { // Handle error…
                completionHandler(success: false, errorString: error)
            } else {
//            print("The result is \(result)")
                self.sessionID = result["session"]!!["id"] as? String
                self.userID = result["account"]!!["key"] as? String
                
                self.findUserData({ (success, errorString) -> Void in
                    if errorString != nil{
                        print("error came up")
                        completionHandler(success: false, errorString: errorString)
                    }else {
                        completionHandler(success: true, errorString: nil)
                    }
                })
                
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as! AppDelegate
                
                appDelegate.firstName = result["account"]!!["firstName"] as? String
                appDelegate.lastName = result["account"]!!["lastName"] as? String
                
                completionHandler(success: true, errorString: nil)
            }
        }
        
    }
    
    func findUserData(completionHandler: (success: Bool, errorString: NSError?) -> Void) {

        let parameters = [String:AnyObject]()
        
        taskForGETMethod(Methods.UdacityUser + self.userID! , base: "Udacity", parameters: parameters) { (result, error) -> Void in
            if error != nil { // Handle error…
                completionHandler(success: false, errorString: error)
            } else {
                print("The result is \(result)")
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as! AppDelegate
                
                appDelegate.firstName = result["user"]!!["first_name"] as? String
                appDelegate.lastName = result["user"]!!["last_name"] as? String
                appDelegate.UserId = self.userID!
                
                completionHandler(success: true, errorString: nil)
            }
        }
        
    }

    func getAllStudentLocations(completionHandler: (success: Bool, locations:[StudentObject]?, errorString: NSError?) -> Void) {
        var locations1 = AnyObject!()
        self.findLocations() { (success, list, error) in
            if success {
                
                locations1 = list! as! [String:AnyObject]
                let locations = locations1["results"] as! [[String:AnyObject]]
                
                let studentList = StudentObject.StudentInfoFromResults(locations)

                completionHandler(success: true, locations: studentList, errorString: nil)
            }
            else {
                completionHandler(success: success,locations: nil, errorString: error)
            }
            
        }
        
        
    }
    
    func findLocations(completionHandler: (success: Bool,list: AnyObject?, errorString: NSError?) -> Void) {
        
        var parameters = [String:AnyObject]()
        parameters["order"] = "-updatedAt"
        
        taskForGETMethod(Methods.StudentLocation, base: "point", parameters: parameters) { (result, error) -> Void in
            if error != nil { // Handle error…
                completionHandler(success: false, list: nil, errorString: error)
            } else {
//                print("The result is \(result)")
                let list1 = result
                completionHandler(success: true, list: list1, errorString: nil)
            }
        }
        
    }
    
    func setPinFor(uniqueID:String, first_name:String, last_name:String, mapString:String, lat:Double, long:Double, url:String, completionHandler:(success:Bool, errorString:NSError?)-> Void) {
        
        let parameters = [String:AnyObject]()
        let jsonBody = ["uniqueKey" :uniqueID, "firstName":first_name, "lastName":last_name, "mapString":mapString, "mediaURL":url, "latitude":lat, "longitude":long]
        
        taskForPOSTMethod(Methods.StudentLocation, base: "Parse", parameters: parameters, jsonBody: jsonBody) { (result, error) -> Void in
            if error != nil {
                completionHandler(success: false, errorString: error)
            } else {
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    func performLogout(completionHandler:(success:Bool, errorString:NSError?)->Void) {
        
        let parameters = [String:AnyObject]()
        
        taskForDELETEMethod(Methods.UdacitySession, base: "Udacity", parameters: parameters) { (result, error) -> Void in
            if error != nil {
                completionHandler(success: false, errorString: error)
            }else {
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    
    
}