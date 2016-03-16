//
//  MapViewController.swift
//  onthemap
//
//  Created by raxit cholera on 12/23/15.
//  Copyright © 2015 kodeguide. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        title = " On The Map "
        mapView.delegate = self;
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                if app.canOpenURL(NSURL(string: toOpen)!){
                    app.openURL(NSURL(string: toOpen)!)
                }
            }
        }
    }
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print(view)
    }
    
    
    func loadData() {
        
        UdacityClient.sharedInstance().getAllStudentLocations(){ (success, locationsresponse,errorString) in
            if success {
                
                // We will create an MKPointAnnotation for each dictionary in "locations". The
                // point annotations will be stored in this array, and then provided to the map view.
                var annotations = [MKPointAnnotation]()
                
                for dictionary in locationsresponse!{
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(dictionary.lat!)
                    let long = CLLocationDegrees(dictionary.long!)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = dictionary.first_name!
                    let last = dictionary.last_name!
                    let mediaURL = dictionary.URLlink!
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    
                    annotations.append(annotation)
                }
                
                // When the array is complete, we add the annotations to the map.
                performUIUpdatesOnMain({ () -> Void in
                    self.mapView.addAnnotations(annotations)
                })
                
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