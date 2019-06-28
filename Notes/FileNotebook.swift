//
//  FileNotebook.swift
//  Notes
//
//  Created by n.kuznetsov on 25/06/2019.
//  Copyright © 2019 n.kuznetsov. All rights reserved.
//

import Foundation


class FileNotebook {
    private(set) var notes = [String: [String: Any]]()
    private let dirName = "notebook"
    // В случае дубликата - создаю новую заметку-копию,
    // в которой только переопределяю uid по дефолту
    func add(_ note: Note) {
        if notes[note.uid] == nil {
            notes[note.uid] = note.json
        } else {
            let newUid = UUID().uuidString
            let newNote = Note(title: note.title,
                               content: note.content,
                               priority: note.priority,
                               uid: newUid,
                               color: note.color,
                               selfDestructionDate: note.selfDestructionDate)
            notes[newUid] = newNote.json
        }
    }
    
    func remove(with uid: String) {
        // если элемента по ключу нет, то removeValue
        // просто вернет nil, ничего плохого не будет
        notes.removeValue(forKey: uid)
    }
    
    func saveToFile() {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let filePath = path.appendingPathComponent(dirName)
        do {
            let data = try JSONSerialization.data(withJSONObject: notes, options: [])
            try data.write(to: filePath)
        } catch {
            print("Something went wrong with saving!")
        }
    }
    
    func loadFromFile() {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let filePath = path.appendingPathComponent(dirName)
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                let data = try Data(contentsOf: filePath)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let json = json as? Dictionary<String, Dictionary<String, Any>> {
                    notes = json
                } else {
                    print("Can't parse json from file: \(filePath)")
                }
            } catch {
                print("Something went wrong with loading!")
            }
        } else {
            print("File doesn't exist")
        }
    }
}
