//
//  StudentArray.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 5/8/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation

class StudentArray {
    
    static let sharedInstance = StudentArray()
    private init(){}
    var studentArray = [Student]()
    
}


