//
//  LoginController.swift
//  onthemap
//
//  Created by raxit cholera on 12/23/15.
//  Copyright © 2015 kodeguide. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit


class LoginController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!

    @IBOutlet weak var passwordTextBox: UITextField!
    @IBOutlet weak var userNameTextBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.debugTextLabel.text = ""
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["public_profile","email"]
        // Do any additional setup after loading the view, typically from a nib.
        if(FBSDKAccessToken.currentAccessToken() != nil) {
            completeLogin()
        }
        

    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error != nil)
        {
            print(error.localizedDescription)
            return
        }
        if let userToken = result.token
        {
            let token:FBSDKAccessToken = result.token
            print("Token received is  \(FBSDKAccessToken.currentAccessToken().tokenString)")
            print("User Id received is  \(FBSDKAccessToken.currentAccessToken().userID)")
            completeLogin()

        }
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Logedout")
    }
    
    @IBAction func LoginBtnClicked(sender: AnyObject) {
       
        if (userNameTextBox.text != "" && passwordTextBox.text != "" ){
        
        UdacityClient.sharedInstance().authenticateWithViewController(self) { (success,errorString) in
            if success {
                self.completeLogin()
            } else {
                performUIUpdatesOnMain({ () -> Void in
                    let alertController = UIAlertController(title: "Login Failed", message: errorString?.localizedDescription , preferredStyle: UIAlertControllerStyle.Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    self.displayError(errorString?.localizedDescription)
                })
                
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
