//
//  StudentClass.swift
//  onthemap
//
//  Created by Raxit Cholera on 1/1/16.
//  Copyright © 2016 kodeguide. All rights reserved.
//

import Foundation
import UIKit

struct StudentObject {
    var first_name:String?
    var last_name:String?
    var URLlink:String?
    var lat:Double?
    var long:Double?
    init(dict:[String:AnyObject]) {
        self.first_name = dict["firstName"] as? String
        self.last_name = dict["lastName"] as? String
        self.lat = dict["latitude"] as? Double
        self.long = dict["longitude"] as? Double
        self.URLlink = dict["mediaURL"] as? String
    }
    
    static func StudentInfoFromResults(results: [[String:AnyObject]]) -> [StudentObject] {
        
        var students = [StudentObject]()
        
        // iterate through array of dictionaries, each Student is a dictionary
        for result in results {
            students.append(StudentObject(dict: result))
        }
        
        return students
    }
    /*class StudentArray {
    
        var myStudentLocations : [StudentObject] = [StudentObject]()
    
        class var sharedInstance: StudentObject {
            struct Singleton {
                static let instance = StudentArray()
            }
            return Singleton.instance
        }
    }*/
    
}
