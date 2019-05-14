//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 5/4/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        print("view")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
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
    
    private func displayError(_ errorString: String?) {
        let alert = UIAlertController(title: "Error!", message: errorString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func login() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: AnyObject) {
        self.activityIndicator.startAnimating()
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayError("Please input your email and password")
        }
        UdacityClient.sharedInstance().loginUser(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (success, errorString) in
            DispatchQueue.main.async {
                if (success != nil) {
                    self.login()
                    self.activityIndicator.stopAnimating()
                } else {
                    self.reloadInputViews()
                    self.displayError(errorString?.userInfo.description)
                }
            }
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
        let url = URL (string: "https://auth.udacity.com/sign-up")
        UIApplication.shared.openURL(url!)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if passwordTextField.isFirstResponder {
                self.view.frame.origin.y = keyboardSize.height * (-1)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

