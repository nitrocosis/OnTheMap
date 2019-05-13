//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 5/7/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation

class ParseClient {
    
    var session = URLSession.shared
    
    //MARK: Get
    func taskForGetLocation (_ method: String, url: URL, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        let url = URL(string: ParseConstants.URLConstants.BaseURL + ParseConstants.Methods.StudentLocations)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.addValue(ParseConstants.API.APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseConstants.API.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
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
            
        }
        task.resume()
    }
    
    //MARK: Get plural
    func taskForGetLocations(_ method: String, url: URL, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")!)
        request.httpMethod = "GET"
        request.addValue(ParseConstants.API.APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseConstants.API.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
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
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
            } catch {
                return
            }
            if let result = parsedResult["results"] as? [[String:AnyObject]]{
                completion(result as AnyObject,nil)
            }
            print(String(data: data!, encoding: .utf8)!)
            
        }
        
        task.resume()
    }
    
    //MARK: Post
    func taskForPostLocation(jsonBody: [String: Any], completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let url = URL(string: ParseConstants.URLConstants.BaseURL + ParseConstants.Methods.StudentLocations)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue(ParseConstants.API.APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseConstants.API.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            print("POSTING LOCATION: \(jsonBody)")
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
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
            
            self.convertDataWithCompletionHandler(data!, completion)
        }
        task.resume()
    }
    
    //MARK: Put
    func taskForPutLocation(_ method: String, url: URL, jsonBody: [AnyObject], completionHandlerForPut: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let url = URL(string: ParseConstants.URLConstants.BaseURL + ParseConstants.Methods.StudentLocations + ParseConstants.JSONResponseKeys.ObjectID)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(ParseConstants.API.APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseConstants.API.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPut(nil, NSError(domain: "taskForPut", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("\(error!)")
                return
            }
            
            guard data != nil else {
                sendError("No data")
                return
            }
            
            completionHandlerForPut(data as AnyObject, nil)
        }
        task.resume()
    }
    
    //Mark: Convert
    public func convertDataWithCompletionHandler(_ data: Data, _ completion: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsed: AnyObject! = nil
        do {
            parsed = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            print("POST LOCATION RESPONSE: \(parsed)")
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completion(nil, NSError(domain: "convertData", code: 1, userInfo: userInfo))
        }
        
        completion(parsed, nil)
    }
    
    //MARK: Shared
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var shared = ParseClient()
        }
        
        return Singleton.shared
    }
    
    
}


