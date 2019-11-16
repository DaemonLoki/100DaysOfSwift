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
        ],
        "Superheroes": [
            ("Superman", "Clark Kent"),
            ("Batman", "Bruce Wayne"),
            ("Spiderman", "Peter Parker"),
            ("twostraws", "Paul Hudson"),
            ("Deadpool", "Wade Wilson"),
            ("Iron Man", "Tony Stark"),
            ("Hulk", "Bruce Banner"),
            ("Captain America", "Steve Rogers"),
            ("Captain Marvel", "Carol Danvers"),
            ("Black Widow", "Natasha Romanoff"),
        ]
    ]
    
    static func topic(named name: String) -> [(String, String)]? {
        return topics.keys.contains(name) ? topics[name] : nil
    }
    
}
