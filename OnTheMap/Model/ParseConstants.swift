//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 5/7/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation

class ParseConstants {
    
    struct API {
        static let APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct URLConstants {
        static let ApiScheme: String = "https"
        static let ApiHost: String = "parse.udacity.com"
        static let ApiPath: String = "/parse/classes"
        static let BaseURL: String = "https://parse.udacity.com/parse/classes"
    }
    
    struct Methods {
        static let StudentLocations = "/StudentLocation"
    }
    
    struct URLParameters {
        static let getLocations: String = "?limit=100&order=-updatedAt"
    }
    
    struct JSONResponseKeys {
        static let ObjectID: String = "objectId"
        static let UniqueKey: String = "uniqueKey"
        static let firstName: String = "firstName"
        static let lastName: String = "lastName"
        static let mapString: String = "mapString"
        static let mediaURL: String = "mediaURL"
        static let latitude: String = "latitude"
        static let longitude: String = "longitude"
        static let createdAt: String = "createdAt"
        static let updatedAt: String = "-updatedAt"
        static let requestToken = "request_token"
        static let SessionID = "session_id"
        static let ACL: String = "ACL"
    }
}



