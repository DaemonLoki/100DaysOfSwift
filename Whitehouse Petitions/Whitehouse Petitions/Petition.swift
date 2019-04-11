//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by Stefan Blos on 11.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//
struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
