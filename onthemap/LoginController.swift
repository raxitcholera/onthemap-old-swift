//
//  LoginController.swift
//  onthemap
//
//  Created by raxit cholera on 12/23/15.
//  Copyright © 2015 kodeguide. All rights reserved.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: UIButton!
    
    @IBOutlet weak var passwordTextBox: UITextField!
    @IBOutlet weak var userNameTextBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.debugTextLabel.text = ""
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func FaceBookLoginClicked(sender: UIButton) {
    }
    
    @IBAction func LoginBtnClicked(sender: AnyObject) {
       
        if (userNameTextBox.text != "" && passwordTextBox.text != "" ){
        
        UdacityClient.sharedInstance().authenticateWithViewController(self) { (success,errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString?.localizedDescription)
            }
        }
        }else {
            debugTextLabel.text = "UserName and Password mendatory"
        }
        
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UITabBarController
            UIApplication.sharedApplication().keyWindow?.rootViewController = controller

        })
    }
    
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                self.debugTextLabel.text = errorString
            }
        })
    }
    
}
