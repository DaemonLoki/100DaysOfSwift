//
//  NotesHandler.swift
//  Notes Clone
//
//  Created by Stefan Blos on 18.07.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import Foundation

class NotesHandler {
    
    let userDefaults: UserDefaults
    static let notesKey = "notes"
    var notes: [Note]?
    
    init() {
        self.userDefaults = UserDefaults.standard
    }
    
    func saveNotes(notes: [Note]) {
        self.notes = notes
        DispatchQueue.global().async {
            let jsonEncoder = JSONEncoder()
            if let notesToSave = try? jsonEncoder.encode(notes) {
                let defaults = UserDefaults.standard
                defaults.set(notesToSave, forKey: NotesHandler.notesKey)
            } else {
                print("Failed to save notes")
            }
        }
    }
    
    func loadNotes(completionHandler: @escaping ([Note]) -> Void) {
        if let notes = notes {
            completionHandler(notes)
            return
        }
        
        DispatchQueue.global().async { () in
            let defaults = UserDefaults.standard
            if let savedNotes = defaults.object(forKey: NotesHandler.notesKey) as? Data {
                let decoder = JSONDecoder()
                do {
                    let notes: [Note] = try decoder.decode([Note].self, from: savedNotes)
                    self.notes = notes
                    DispatchQueue.main.async {
                        completionHandler(notes)
                    }
                    
                } catch {
                    self.notes = [Note]()
                    completionHandler([Note]())
                    return
                }
            }
        }
    }
    
    func saveNote(note: Note) {
        guard let notes = notes else {
            fatalError("Notes not initialized")
        }
        for savedNote in notes {
            if note.id == savedNote.id {
                savedNote.text = note.text
                savedNote.timeSaved = Date()
                break
            }
        }
        saveNotes(notes: notes)
    }
    
}
