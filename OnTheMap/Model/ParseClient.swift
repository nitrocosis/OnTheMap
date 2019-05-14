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
    func taskForGetLocations(_ method: String, url: URL, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")!)
        request.httpMethod = "GET"
        request.addValue(ParseConstants.API.APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseConstants.API.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.sendError("Something went wrong, please try again", "taskForGetLocations", completion)
                return
            }
            
            guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                self.sendError("Something went wrong, please try again", "taskForGetLocations", completion)
                return
            }
            
            if httpStatusCode >= 200 && httpStatusCode < 300 {
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                } catch {
                    self.sendError("Couldn't parse response", "taskForGetLocations", completion)
                    return
                }
                if let result = parsedResult["results"] as? [[String:AnyObject]]{
                    completion(result as AnyObject, nil)
                }
            }
            else{
                self.sendErrorForHttpStatusCode(httpStatusCode, "taskForGetLocations", completion)
            }
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
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.sendError("Something went wrong, please try again", "taskForPostLocation", completion)
                return
            }
            
            guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                self.sendError("Something went wrong, please try again", "taskForPostLocation", completion)
                return
            }
            
            if httpStatusCode >= 200 && httpStatusCode < 300 {
                var parsed: AnyObject! = nil
                do {
                    parsed = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                } catch {
                    self.sendError("Couldn't parse response", "taskForPostLocation", completion)
                }
                
                completion(parsed, nil)
            }
            else{
                self.sendErrorForHttpStatusCode(httpStatusCode, "taskForPostLocation", completion)
            }
        }
        task.resume()
    }
    
    //MARK: Shared
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var shared = ParseClient()
        }
        
        return Singleton.shared
    }
    
    
}
