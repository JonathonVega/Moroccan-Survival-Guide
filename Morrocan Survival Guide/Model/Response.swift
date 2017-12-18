//
//  Response.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 12/16/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import Foundation
import UIKit

class Response {
    let creatorName: String?
    let response: String?
    let createDate: String?
    let key: String?
    
    init(creatorName:String, response:String, createDate:String, key:String) {
        self.creatorName = creatorName
        self.response = response
        self.createDate = createDate
        self.key = key
    }
}
