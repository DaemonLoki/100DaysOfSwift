//
//  CardCell.swift
//  Pairs
//
//  Created by Stefan Blos on 16.11.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    @IBOutlet var textLabel: UILabel!
    
    private var content: String?
    private var isContentHidden = true
    var isActive = true
    
    func configure(content: String) {
        self.content = content
        self.textLabel.text = "Hidden"
    }
    
    func flip() {
        isContentHidden.toggle()
        
        if isContentHidden {
            self.textLabel.text = "Hidden"
        } else {
            self.textLabel.text = self.content ?? "Unknown"
        }
    }
    
    func deactivate() {
        isActive = false
        self.contentView.alpha = 0.5
    }
    
}
