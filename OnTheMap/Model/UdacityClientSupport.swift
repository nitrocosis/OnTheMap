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
                completion(user as! User, nil)
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
    
    func sendError(_ errorString: String, _ domain: String, _ completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        let userInfo = [NSLocalizedDescriptionKey : errorString]
        completion(nil, NSError(domain: domain, code: 1, userInfo: userInfo))
    }
    
    func sendErrorForHttpStatusCode(_ httpStatusCode: Int, _ domain: String, _ completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        switch(httpStatusCode) {
        case 400: // BadRequest
            sendError("Bad request, please try again", domain, completion)
        case 401: // Invalid Credentials
            sendError("Invalid Credentials, please try again", domain, completion)
        case 403: // Invalid Credentials
            sendError("Unauthorized, please try again", domain, completion)
        case 410: // URL Changed
            sendError("URL changed, please try again", domain, completion)
        case 500: // URL Changed
            sendError("Server error, please try again later", domain, completion)
        default:
            sendError("Something went wrong, please try again", domain, completion)
        }
    }
}





