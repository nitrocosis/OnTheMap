//
//  UdacityClientSupport.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 5/6/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func loginUser (username: String, password: String, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        taskForPost(url: URL(string: UdacityConstants.URLConstants.APISession)!, username: username, password: password) { (results, error) in
            if let error = error {
                completion(nil, error)
            }
            else {
                completion(results, nil)
            }
        }
    }
    
    func getUserData (completion: @escaping (_ result: User?, _ error: NSError?) -> Void){
        
        taskForGet() { (user, error) in
            if let error = error {
                completion(nil, error as NSError)
            } else {
                completion(user, nil)
            }
        }
        
    }
    
    func deleteSession (completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        taskForDelete() { (results, error) in
            if let error = error {
                print(error)
                completion(nil, error)
            } else {
                print("Log Out Complete")
                completion(true as AnyObject, nil)
            }
        }
        
    }
}





