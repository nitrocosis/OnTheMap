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
    func taskForGet(completion: @escaping (_ result: User?, _ error: Error?) -> Void) {
        let url = URL(string: UdacityConstants.URLConstants.PublicUserData + userId!)
        print("GET USER DATA URL: " + url!.absoluteString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGet", code: 1, userInfo: userInfo))
            }
            
            
            guard (error == nil) else {
                sendError("\(error!)")
                return
            }
            
            guard data != nil else {
                sendError("No data")
                return
            }
            
            let newData = data?.subdata(in: 5..<data!.count)
            if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                let dict = json as? [String:Any],
                let firstName = dict[UdacityConstants.JSONResponseKeys.firstName] as? String,
                let lastName = dict[UdacityConstants.JSONResponseKeys.lastName] as? String {
                
                let user = User(firstName: firstName, lastName: lastName)
                completion(user , nil)
            } else {
                sendError("Couldn't parse response")
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
            func sendError(_ error: String) {
                print("Error logging in: " + error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForPost", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("\(error!)")
                return
            }
            
            
            guard data != nil else {
                sendError("No data")
                return
            }
            
            let newData = data?.subdata(in: 5..<data!.count)
            if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                let dict = json as? [String:Any],
                let sessionDict = dict["session"] as? [String: Any],
                let accountDict = dict["account"] as? [String: Any]  {
                
                let key = accountDict["key"] as? String
                self.userId = key
                completion(key as AnyObject, nil)
                
            } else {
                let errString = "Couldn't parse response"
                let error = [NSLocalizedDescriptionKey : errString]
                completion(nil, NSError(domain: "taskForPost", code: 1, userInfo: error))
            }
            
        }
        task.resume()
    }
    
    //MARK: Delete
    func taskForDelete (completion: @escaping (_ result: String?, _ error: NSError?) -> Void)  {
        
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
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForDelete", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("\(error!)")
                return
            }
            
            guard data != nil else {
                sendError("No data")
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            completion(String(data: newData!, encoding: .utf8), nil)
        }
        task.resume()
    }
    
    //MARK: Convert
    public func convertDataWithCompletionHandler(_ data: Data, completion: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completion(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completion(parsedResult, nil)
    }
    
    //MARK: Shared
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var shared = UdacityClient()
        }
        
        return Singleton.shared
    }
    
    
    
    
}







