//
//  UdacityClient.swift
//  onthemap
//
//  Created by raxit cholera on 12/23/15.
//  Copyright © 2015 kodeguide. All rights reserved.
//
import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}