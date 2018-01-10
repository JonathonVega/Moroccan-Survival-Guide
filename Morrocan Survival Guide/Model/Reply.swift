//
//  Reply.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 12/16/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import Foundation
import UIKit

class Reply {
    let creatorKey: String?
    let creatorName: String?
    let reply: String?
    let createDate: String?
    let key: String?
    
    init(creatorKey: String, creatorName:String, reply:String, createDate:String, key:String) {
        self.creatorKey = creatorKey
        self.creatorName = creatorName
        self.reply = reply
        self.createDate = createDate
        self.key = key
    }
}
