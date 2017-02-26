//
//  User.swift
//  hackbu17ipapp
//
//  Created by Charles DiGiovanna on 2/25/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import Foundation

class User {
    var id: String = ""
    var name: String = ""
    var username: String = ""
    var score: Int = 0
    
    init(id: String, name: String, username: String, score: Int) {
        self.id = id
        self.name = name
        self.username = username
        self.score = score
    }
}
