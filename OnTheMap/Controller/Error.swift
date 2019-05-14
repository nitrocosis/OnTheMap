//
//  Error.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 5/14/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation
import UIKit

class Error {
    

static let sharedInstance = Error()
private init(){}

    private func displayError(_ errorString: String?) {
        let alert = UIAlertController(title: "Error!", message: errorString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
