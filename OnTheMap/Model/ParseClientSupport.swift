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
    func getStudentLocations (completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
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


