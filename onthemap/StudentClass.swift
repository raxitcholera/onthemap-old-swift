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
    var lat:Double?
    var long:Double?
    init(dict: Dictionary<String, AnyObject>) {
        self.first_name = dict["first_name"] as? String
        self.last_name = dict["last_name"] as? String
    }
}
