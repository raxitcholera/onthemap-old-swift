//
//  UdacityConstants.swift
//  onthemap
//
//  Created by raxit cholera on 12/23/15.
//  Copyright © 2015 kodeguide. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        
        static let ParseApiKey : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

        static let BaseURL : String = "http://api.parse.com/1/"
        static let BaseURLSecure : String = "https://api.parse.com/1/"        
        static let UdacityBaseURLSecure :String = "https://www.udacity.com/api/"
        
    }

    struct Methods {
 
        static let StudentLocation = "classes/StudentLocation"
        static let UdacitySession = "session"
        static let UdacityUser = "users/"
        
    }
    
    
}