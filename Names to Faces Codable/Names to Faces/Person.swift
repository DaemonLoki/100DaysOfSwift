//
//  Person.swift
//  Names to Faces
//
//  Created by Stefan Blos on 20.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
