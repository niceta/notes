//
//  Note.swift
//  Notes
//
//  Created by n.kuznetsov on 17/06/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit


enum Priority {
    case low
    case normal
    case high
}

struct Note {
    let title: String
    let content: String
    let priority: Priority
    let uid: String
    let color: UIColor
    let selfDestructionDate: Date?
    
    init(title: String,
         content: String,
         priority: Priority,
         uid: String = UUID().uuidString,
         color: UIColor = UIColor.white,
         selfDestructionDate: Date? = nil) {
        
        self.title = title
        self.content = content
        self.priority = priority
        self.uid = uid
        self.color = color
        self.selfDestructionDate = selfDestructionDate
    }
}
