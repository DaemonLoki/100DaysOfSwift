//
//  Capital.swift
//  Capital Cities
//
//  Created by Stefan Blos on 17.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var link: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, link: String) {
        self.title = title
        self.coordinate = coordinate
        self.link = link
    }

}
