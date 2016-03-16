//
//  AddStudentLocationViewController.swift
//  onthemap
//
//  Created by raxit cholera on 12/29/15.
//  Copyright © 2015 kodeguide. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class AddStudentLocationViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var mediaURL: UITextView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var searchString:String?
    var lat:Double?
    var long:Double?
    
    @IBAction func goBackClicked(sender: UIButton) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    var localSearchResponse : MKLocalSearchResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)
        mediaURL.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        SearchForLocation()
    }
    
    func SearchForLocation() {        
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchString
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = appDel.firstName! + " " + appDel.lastName!
            self.lat = localSearchResponse!.boundingRegion.center.latitude
            self.long = localSearchResponse!.boundingRegion.center.longitude
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = pointAnnotation.coordinate
            self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, 2000, 2000), animated: true)
            self.mapView.addAnnotation(pinAnnotationView.annotation!)
        }
    }
    
    
    @IBAction func SubmitBtnClicked(sender: UIButton) {
        
        if mediaURL.text != "" {
        
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        UdacityClient.sharedInstance().setPinFor(appDel.UserId!, first_name:appDel.firstName!, last_name:appDel.lastName!, mapString:searchString!, lat:self.lat!, long:self.long!, url:self.mediaURL.text!) { (sucess,error) in
             print("Location Added Successfully")

            if sucess {
                let alert = UIAlertController(title: "Alert", message: "Location Added Successfully", preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                    self.dismissThisView()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "Location Not added", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please add Url first", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func dismissThisView() {
        [self.cancelBtn .sendActionsForControlEvents(UIControlEvents.TouchUpInside)]
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
