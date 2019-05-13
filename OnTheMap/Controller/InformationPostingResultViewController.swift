//
//  InformationPostingResultViewController.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 4/30/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostingResultViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var annotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (annotation != nil) {
            self.mapView.addAnnotation(annotation!)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //MARK: Actions
    @IBAction func saveButton(_ sender: Any) {
        activityIndicator.startAnimating()
        
        UdacityClient.sharedInstance().getUserData() { (userOptional, error) in
            if (error != nil) {
                self.displayError(error?.userInfo.description)
            } else {
                let user = userOptional as! User
                print("Got user data: \(user.firstName) \(user.lastName)")
                // usleep(3000000)
                ParseClient.sharedInstance().postStudentLocation(user, self.annotation!) { (success, error) in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        if (success != nil) {
                            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarViewController")
                            self.present(controller, animated: true, completion: nil)
                        } else {
                            self.displayError(error?.userInfo.description)
                        }
                    }
                }
            }
        }
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
    
    private func displayError(_ errorString: String?) {
        let alert = UIAlertController(title: "Error!", message: errorString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}





