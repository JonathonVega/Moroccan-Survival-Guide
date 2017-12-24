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
    var subject: String?
    var description: String?
    var creator: String?
    var threadID: String?
    var responseCount: Int?
    
    init(subject:String, description:String, creator:String, threadID:String, responseCount:Int) {
        self.subject = subject
        self.description = description
        self.creator = creator
        self.threadID = threadID
        self.responseCount = responseCount
    }
    
    
}
