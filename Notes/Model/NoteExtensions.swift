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
                return Priority(rawValue: priority) ?? .normal
            }
            return .normal
        }
        
        var color: UIColor {
            if let colors = json["color"] as? [CGFloat], colors.count == 4 {
                return UIColor(red: colors[0], green: colors[1], blue: colors[2], alpha: colors[3])
            }
            return .white
        }
        
        var selfDestructionDate: Date? {
            if let date = json["selfDestructionDate"] as? Double {
                return Date(timeIntervalSince1970: TimeInterval(date))
            }
            return nil
        }
        
        return Note(title: title,
                    content: content,
                    priority: priority,
                    uid: uid,
                    color: color,
                    selfDestructionDate: selfDestructionDate)
    }
    
    var json: [String: Any] {
        var result: [String: Any] = [:]
        result["uid"] = self.uid
        result["title"] = self.title
        result["content"] = self.content
        
        if self.priority != .normal {
            result["priority"] = self.priority.rawValue
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

extension Note {
    static var exampleNotes: [Note] {
        return [
            Note(title: "first",
                     content: "some content",
                     priority: .normal,
                     color: .red,
                     selfDestructionDate: nil),
            Note(title: "second",
                 content: "some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content",
                 priority: .high,
                 color: .blue,
                 selfDestructionDate: Date()),
            Note(title: "third",
                 content: "third content",
                 priority: .low),
            Note(title: "еще заметка",
                 content: "some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content",
                 priority: .low,
                 color: .green),
            Note(title: "и еще",
                 content: "some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content some long content",
                 priority: .low,
                 color: .gray),
            Note(title: "и какая то еще",
                 content: "third content",
                 priority: .low,
                 color: .black),
            Note(title: "и какая то еще 1",
                 content: "third content",
                 priority: .low,
                 color: .purple),
            Note(title: "и какая то еще 2",
                 content: "third content",
                 priority: .low,
                 color: .orange),
            Note(title: "и какая то еще 3",
                 content: "third content",
                 priority: .low,
                 color: .yellow)
        ]
    }
}

extension UIColor {
    var rgba: [CGFloat] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [red, green, blue, alpha]
    }
}
