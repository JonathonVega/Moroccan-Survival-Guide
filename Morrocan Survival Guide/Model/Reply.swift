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
    let creatorName: String?
    let reply: String?
    let createDate: String?
    let key: String?
    
    init(creatorName:String, reply:String, createDate:String, key:String) {
        self.creatorName = creatorName
        self.reply = reply
        self.createDate = createDate
        self.key = key
    }
}
