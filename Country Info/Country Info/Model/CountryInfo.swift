//
//  CountryInfo.swift
//  Country Info
//
//  Created by Stefan Blos on 16.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

struct CountryInfo: Codable {
    var nativeName: String
    var capital: String
    var demonym: String
    var population: Int
    var area: Int
    var subregion: String
    var currencies: [Currency]
    var languages: [Language]
}

struct Currency: Codable {
    var name: String
    var symbol: String
}

struct Language: Codable {
    var name: String
}
