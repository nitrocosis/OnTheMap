//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 5/6/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation

class UdacityClient {
    var session = URLSession.shared
    var userId: String? = nil
    
    //MARK: Get
    func taskForGet(completion: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) {
        let url = URL(string: UdacityConstants.URLConstants.PublicUserData + userId!)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.sendError("Something went wrong, please try again", "taskForGet", completion)
                return
            }
            
            guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                // Since there is no HTTP StatusCode (which will bnever happen). Adding it just to safely
                // unwrap the StatusCode
                self.sendError("Something went wrong, please try again", "taskForGet", completion)
                return
            }
            
            if httpStatusCode >= 200 && httpStatusCode < 300 {
                // Since Status Code is valid. Process Data here only.
                // This is syntax to create Range in Swift 5
                let newData = data?.subdata(in: 5..<data!.count)
                if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                    let dict = json as? [String:Any],
                    let firstName = dict[UdacityConstants.JSONResponseKeys.firstName] as? String,
                    let lastName = dict[UdacityConstants.JSONResponseKeys.lastName] as? String {
                    
                    let user = User(firstName: firstName, lastName: lastName)
                    completion(user as AnyObject , nil)
                } else {
                    self.sendError("Couldn't parse response", "taskForGet", completion)
                }
            }
            else{
                self.sendErrorForHttpStatusCode(httpStatusCode, "taskForGet", completion)
            }
        }
        task.resume()
    }
    
    //MARK: Post
    
    func taskForPost(url: URL, username: String, password: String, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let url = URL(string: UdacityConstants.URLConstants.PublicUserURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.sendError("Something went wrong, please try again", "taskForPost", completion)
                return
            }
            
            guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                // Since there is no HTTP StatusCode (which will bnever happen). Adding it just to safely
                // unwrap the StatusCode
                self.sendError("Something went wrong, please try again", "taskForPost", completion)
                return
            }
            
            if httpStatusCode >= 200 && httpStatusCode < 300 {
                // Since Status Code is valid. Process Data here only.
                // This is syntax to create Range in Swift 5
                let range = 5..<data!.count
                let newData = data?.subdata(in: range) /* subset response data! */
                // Continue processing the data and deserialize it
                if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                    let dict = json as? [String:Any],
                    let sessionDict = dict["session"] as? [String: Any],
                    let accountDict = dict["account"] as? [String: Any]  {
                    
                    let key = accountDict["key"] as? String
                    self.userId = key
                    completion(key as AnyObject, nil)
                    
                } else {
                    self.sendError("Couldn't parse response", "taskForPost", completion)
                }
            }
            else{
                self.sendErrorForHttpStatusCode(httpStatusCode, "taskForPost", completion)
            }
        }
        task.resume()
    }
    
    //MARK: Delete
    func taskForDelete (completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void)  {
        
        let url = URL(string: UdacityConstants.URLConstants.PublicUserURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.sendError("Something went wrong, please try again", "taskForDelete", completion)
                return
            }
            
            guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                // Since there is no HTTP StatusCode (which will bnever happen). Adding it just to safely
                // unwrap the StatusCode
                self.sendError("Something went wrong, please try again", "taskForDelete", completion)
                return
            }
            
            if httpStatusCode >= 200 && httpStatusCode < 300 {
                // Since Status Code is valid. Process Data here only.
                // This is syntax to create Range in Swift 5
                let range = 5..<data!.count
                let newData = data?.subdata(in: range) /* subset response data! */
                // Continue processing the data and deserialize it
                completion(String(data: newData!, encoding: .utf8) as AnyObject, nil)
            }
            else{
                self.sendErrorForHttpStatusCode(httpStatusCode, "taskForDelete", completion)
            }
        }
        task.resume()
    }
    
    //MARK: Shared
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var shared = UdacityClient()
        }
        
        return Singleton.shared
    }
    
    
    
    
}







