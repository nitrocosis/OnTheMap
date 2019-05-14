//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 4/30/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var resultAnnotation: MKPointAnnotation?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        self.activityIndicator.startAnimating()
        if locationTextField.text!.isEmpty || detailsTextField.text!.isEmpty {
            self.displayError("Please enter your location and details")
            return
        }
        getLocation() { (result, error) in
            if (result != nil) {
                self.resultAnnotation = result
                self.resultAnnotation?.title = self.locationTextField.text
                self.resultAnnotation?.subtitle = self.detailsTextField.text
                self.activityIndicator.stopAnimating()
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "InformationPostingResultViewController")
                self.performSegue(withIdentifier: "InformationPostingResultViewController", sender: nil)
                self.present(controller, animated: true, completion: nil)
            } else {
                self.displayError(error?.domain)
            }
        }
    }
    
    func getLocation(completionHandler: @escaping (_ result: MKPointAnnotation?, _ error: NSError?) -> Void) {
        if let locationString = locationTextField.text{
            CLGeocoder().geocodeAddressString(locationString) { (placeMarks, err) in
                guard let firstLocation = placeMarks?.first?.location else {
                    completionHandler(nil, NSError(domain: "Failed to get location", code: 404, userInfo: nil))
                    return
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = firstLocation.coordinate
                completionHandler(annotation, nil)
            }
        }
            
        else{
            completionHandler(nil, NSError(domain: "Failed to get location", code: 404, userInfo: nil))
        }
    }
    
    func displayError(_ errorString: String?) {
        let alert = UIAlertController(title: "Error!", message: errorString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if detailsTextField.isFirstResponder {
                self.view.frame.origin.y = keyboardSize.height * (-1)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InformationPostingResultViewController {
            if (resultAnnotation != nil) {
                vc.annotation = resultAnnotation!
            }
        }
    }
    
}



