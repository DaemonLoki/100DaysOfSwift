//
//  Note.swift
//  Notes Clone
//
//  Created by Stefan Blos on 12.07.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import Foundation

class Note: NSObject, Codable {
    
    var id: UUID
    var text: String
    var timeCreated: Date
    var timeSaved: Date
    
    init(id: UUID, text: String, timeCreated: Date) {
        self.id = id
        self.text = text
        self.timeCreated = timeCreated
        self.timeSaved = timeCreated
    }
}
