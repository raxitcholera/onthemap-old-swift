//
//  InputLocation.swift
//  onthemap
//
//  Created by raxit cholera on 12/29/15.
//  Copyright © 2015 kodeguide. All rights reserved.
//

import Foundation
import UIKit

class InputLocation:UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var locationTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)
        locationTextBox.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func goBackClicked(sender: UIButton) {

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    
    @IBAction func FindLocationClicked(sender: AnyObject) {
        
        if locationTextBox.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Location not mentioned", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailsViewController: AddStudentLocationViewController = segue.destinationViewController as? AddStudentLocationViewController {
        detailsViewController.searchString = self.locationTextBox.text!
            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.locationTextBox.resignFirstResponder()
        return true
    }
    
}