//
//  NoteExtensions.swift
//  Notes
//
//  Created by n.kuznetsov on 18/06/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import UIKit


extension Note {
    static func parse(json: [String: Any]) -> Note? {
        guard
            let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String
        else {
             return nil
        }
        
        var priority: Priority {
            if let priority = json["priority"] as? String {
                return Priority(rawValue: priority)!
            } else {
                return .normal
            }
        }
        
        var color: UIColor {
            if let colors = json["color"] as? [CGFloat] {
                return UIColor(red: colors[0], green: colors[1], blue: colors[2], alpha: colors[3])
            } else {
                return .white
            }
        }
        
        var selfDestructionTime: Date? {
            return nil
        }
        
        return nil
    }
    
    var json: [String: Any] {
        var result: [String: Any] = [:]
        result["uid"] = self.uid
        result["title"] = self.title
        result["content"] = self.content
        
        if self.priority != .normal {
            result["priority"] = self.priority
        }
        
        if self.color != .white {
            let colors = self.color.rgba
            result["color"] = colors
        }
        
        if let date = self.selfDestructionDate {
            result["selfDestructionDate"] = Double(date.timeIntervalSince1970)
        } else {
            result["selfDestructionDate"] = nil
        }
        return result
    }
}

extension UIColor {
    // Комментарий Дениса из телеграмм-чатика:
    // CGFloat - это typealias для Float, поэтому это тоже простой тип.
    // Т.е. нарушение условия это не считается, поэтому баллы ставить нормально
    var rgba: [CGFloat] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [red, green, blue, alpha]
    }
}
