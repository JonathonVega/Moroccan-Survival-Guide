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
    let creatorID: String?
    let creator: String?
    let reply: String?
    let dateCreated: String?
    let key: String?
    
    init(creatorID: String, creator:String, reply:String, dateCreated:String, key:String) {
        self.creatorID = creatorID
        self.creator = creator
        self.reply = reply
        self.dateCreated = dateCreated
        self.key = key
    }
}
