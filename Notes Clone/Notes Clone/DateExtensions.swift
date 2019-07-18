//
//  DateExtensions.swift
//  Notes Clone
//
//  Created by Stefan Blos on 12.07.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import Foundation

extension Date {
    
    public func day() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    public func month() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    
    public func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }
}
