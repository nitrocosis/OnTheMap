//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 4/30/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        getAnnotations()
    }
    
    func getAnnotations() {
        ParseClient.sharedInstance().getStudentLocation { (result, error) in
            StudentArray.sharedInstance.studentArray =  Student.studentInfo(result as! [[String : AnyObject]])
            for student in StudentArray.sharedInstance.studentArray {
                
                let lat = CLLocationDegrees(student.latitude ?? 0)
                let long = CLLocationDegrees(student.longitude ?? 0)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let firstName = student.firstName ?? ""
                let lastName = student.lastName ?? ""
                let mediaURL = student.mediaURL
                var fullName = ""
                if firstName == "" && lastName == ""{
                    fullName = "No Name"
                }
                else if firstName == ""{
                    fullName =  lastName
                }
                else if lastName == ""{
                    fullName = firstName
                }
                else{
                    fullName = "\(firstName) \(lastName)"
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = fullName
                annotation.subtitle = mediaURL
                self.annotations.append(annotation)
            }
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ParseClient.sharedInstance().getStudentLocation { (result, error) in
            print(result ?? "")
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UdacityClient.sharedInstance().deleteSession { (success, error) in
            if (error != nil) {
                self.displayError(error?.userInfo.description)
            } else {
                DispatchQueue.main.async {
                    // Close all open VCs
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        annotations.removeAll()
        mapView.removeAnnotations(self.mapView.annotations)
        getAnnotations()
    }
    
    @IBAction func addButton(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "InformationPostingViewController") as! InformationPostingViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let open = view.annotation?.subtitle! {
                app.openURL(URL(string: open)!)
            }
        }
    }
    
    private func displayError(_ errorString: String?) {
        let alert = UIAlertController(title: "Error!", message: errorString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}




