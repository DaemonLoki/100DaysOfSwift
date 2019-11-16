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
    @IBOutlet var cardBackgroundView: UIView!
    @IBOutlet var cardPatternImageView: UIImageView!
    @IBOutlet var showContentView: UIView!
    
    private let animationDuration = 0.35
    
    private var isContentHidden = true
    var isActive = true
    
    private let patternRows = 5
    private let patternColumns = 5
    
    func configure(content: String, delayedBy delay: Double) {
        // set view layouts
        self.cardBackgroundView.layer.cornerRadius = 10
        self.showContentView.layer.cornerRadius = 10
        
        // set view contents
        self.textLabel.text = content
        self.drawCardPattern()
        
        // animate reveal
        self.contentView.alpha = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.contentView.alpha = 1
            })
        }
    }
    
    private func drawCardPattern() {
        let imageSize = self.cardPatternImageView.frame.size
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.bgRed.cgColor)
            
            let rectSize = 150 / patternRows
            for row in 0..<patternRows {
                for col in 0..<patternColumns {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * rectSize, y: row * rectSize, width: rectSize, height: rectSize))
                    }
                }
            }
        }
        self.cardPatternImageView.image = img
    }
    
    func flip() {
        isContentHidden.toggle()
        
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight/*, .showHideTransitionViews*/]
        
        let viewToHide: UIView = isContentHidden ? showContentView : cardBackgroundView
        let viewToShow: UIView = isContentHidden ? cardBackgroundView : showContentView
        
        viewToShow.isHidden = true
        UIView.transition(with: viewToHide, duration: animationDuration, options: transitionOptions, animations: {
            viewToHide.isHidden = true
        })

        UIView.transition(with: viewToShow, duration: animationDuration, options: transitionOptions, animations: {
            viewToShow.isHidden = false
        })
    }
    
    func deactivate() {
        isActive = false
        UIView.animate(withDuration: animationDuration) {
            self.showContentView.alpha = 0.5
            self.showContentView.backgroundColor = .bgGreen
        }
    }
    
}
