//
//  Topics.swift
//  Pairs
//
//  Created by Stefan Blos on 16.11.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import Foundation

struct Topics {
    
    private static let topics: [String: [(String, String)]] = [
        "Capitals": [
            ("Germany", "Berlin"),
            ("France", "Paris"),
            ("Italy", "Rome"),
            ("Norway", "Oslo"),
            ("USA", "Washington"),
            ("Austria", "Vienna"),
            ("England", "London"),
            ("Poland", "Warsaw"),
            ("Czech", "Prague"),
            ("South Africa", "Pretoria")
        ]
    ]
    
    static func topic(named name: String) -> [(String, String)]? {
        return topics.keys.contains(name) ? topics[name] : nil
    }
    
}
