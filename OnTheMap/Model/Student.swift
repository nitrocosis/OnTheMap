//
//  Student.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 5/7/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation

struct Student {
    
    let ObjectID: String?
    let UniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String?
    let updatedAt: String?
    
    init(dictionary: [String:AnyObject]) {
        
        ObjectID = dictionary[ParseConstants.JSONResponseKeys.ObjectID] as? String ?? ""
        UniqueKey = dictionary[ParseConstants.JSONResponseKeys.UniqueKey] as? String ?? ""
        firstName = dictionary[ParseConstants.JSONResponseKeys.firstName] as? String ?? ""
        lastName = dictionary[ParseConstants.JSONResponseKeys.lastName] as? String ?? ""
        mapString = dictionary[ParseConstants.JSONResponseKeys.mapString] as? String ?? ""
        mediaURL = dictionary[ParseConstants.JSONResponseKeys.mediaURL] as? String ?? ""
        latitude = dictionary[ParseConstants.JSONResponseKeys.latitude] as? Double
        longitude = dictionary[ParseConstants.JSONResponseKeys.longitude] as? Double
        createdAt = dictionary[ParseConstants.JSONResponseKeys.createdAt] as? String ?? ""
        updatedAt = dictionary[ParseConstants.JSONResponseKeys.updatedAt] as? String ?? ""
        
    }
    
    static func studentInfo(_ results: [[String:AnyObject]]) -> [Student] {
        
        var studentLocation = [Student]()
        
        for result in results {
            studentLocation.append(Student(dictionary: result))
        }
        
        return studentLocation
    }
    
    
}


