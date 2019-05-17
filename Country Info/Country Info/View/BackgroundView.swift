//
//  BackgroundView.swift
//  Country Info
//
//  Created by Stefan Blos on 16.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

@IBDesignable
class BackgroundView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
