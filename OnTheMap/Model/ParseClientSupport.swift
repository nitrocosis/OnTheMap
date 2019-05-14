//
//  ParseClientSupport.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 5/7/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation
import MapKit

extension ParseClient {
    func getStudentLocation (completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        taskForGetLocations(ParseConstants.Methods.StudentLocations, url: URL(string: ParseConstants.URLConstants.BaseURL + ParseConstants.Methods.StudentLocations)!) { (results, error) in
            
            if let error = error {
                completion(nil, error)
            } else {
                completion(results, nil)
            }
        }
    }
    
    func postStudentLocation (_ user: User, _ annotation: MKPointAnnotation, completion: @escaping (_ result: Bool?, _ error: NSError?) -> Void) {
        
        let jsonBody: [String: Any] = [
            "uniqueKey": UUID().uuidString,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "mapString": annotation.title!,
            "mediaURL": annotation.subtitle!,
            "latitude": annotation.coordinate.latitude,
            "longitude": annotation.coordinate.longitude
        ]
        taskForPostLocation(jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                completion(nil, error)
            } else {
                completion(true, nil)
            }
        }
        
    }
    
    func putStudentLocation (_ method: String, url: URL, jsonBody: [String:AnyObject], completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void){
        
        let parameters = [ParseConstants.Methods.StudentLocations]
        let put = taskForPutLocation(method, url: URL(string: ParseConstants.URLConstants.BaseURL + ParseConstants.Methods.StudentLocations)!, jsonBody: (jsonBody as AnyObject) as! [AnyObject]) { (results, error) in
            
            var request = URLRequest(url: URL(string: ParseConstants.URLConstants.BaseURL + ParseConstants.Methods.StudentLocations)!)
            if let error = error {
                completion(nil, error)
            } else {
                
                if let results = results?[ParseConstants.JSONResponseKeys.requestToken] as? [[String:AnyObject]] {
                    completion(results as AnyObject, nil)
                } else {
                    completion(nil, NSError(domain: "getStudentLocations", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse student data"]))
                }
            }
        }
        
    }
}


