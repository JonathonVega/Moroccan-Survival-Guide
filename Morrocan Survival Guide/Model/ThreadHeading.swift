//
//  ThreadHeading.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 11/3/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import Foundation
import UIKit

class ThreadHeading {
    var post: String?
    var creator: String?
    var creatorID: String?
    var threadID: String?
    var responseCount: Int?
    
    init(post:String, creator:String, creatorID:String, threadID:String, responseCount:Int) {
        self.post = post
        self.creator = creator
        self.creatorID = creatorID
        self.threadID = threadID
        self.responseCount = responseCount
    }
    
    
}
