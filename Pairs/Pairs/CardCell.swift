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
    @IBOutlet var showContentView: UIView!
    
    private var content: String?
    private var isContentHidden = true
    var isActive = true
    
    func configure(content: String, delayedBy delay: Double) {
        self.content = content
        self.textLabel.text = content
        //self.contentView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.contentView.alpha = 0.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                //self.contentView.transform = .identity
                self.contentView.alpha = 1
            })
        }
    }
    
    func flip() {
        isContentHidden.toggle()
        
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight/*, .showHideTransitionViews*/]
        
        let viewToHide: UIView = isContentHidden ? showContentView : cardBackgroundView
        let viewToShow: UIView = isContentHidden ? cardBackgroundView : showContentView
        
        viewToShow.isHidden = true
        UIView.transition(with: viewToHide, duration: 1.0, options: transitionOptions, animations: {
            viewToHide.isHidden = true
        })

        UIView.transition(with: viewToShow, duration: 0.35, options: transitionOptions, animations: {
            viewToShow.isHidden = false
        })
    }
    
    func deactivate() {
        isActive = false
        self.contentView.alpha = 0.5
    }
    
}
