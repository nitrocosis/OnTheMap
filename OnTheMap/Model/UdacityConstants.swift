//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 5/6/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation

class UdacityConstants {
    
    struct URLConstants {
        
        static let ApiScheme: String = "https"
        static let ApiHost: String = "www.udacity.com"
        static let ApiPath: String = "/api"
        static let BaseURL: String = "https://www.udacity.com/api/"
        static let PublicUserURL: String = "https://onthemap-api.udacity.com/v1/session"
        static let APISession: String = "https://www.udacity.com/api/session"
        static let PublicUserData: String = "https://onthemap-api.udacity.com/v1/users/"
        
    }
    
    struct ParameterKeys {
        static let Udacity: String = "udacity"
        static let username: String = "username"
        static let password: String = "password"
        static let accesstoken: String = "access_token"
    }
    
    struct Methods {
        
        static let StudentLocations = "/StudentLocation"
        static let Session = "/session"
    }
    
    struct JSONResponseKeys {
        static let Key: String = "key"
        static let Account: String = "account"
        static let firstName: String = "first_name"
        static let lastName: String = "last_name"
        static let Session: String = "session"
        static let SessionID: String = "ID"
        static let User: String = "user"
    }
    
    
}


