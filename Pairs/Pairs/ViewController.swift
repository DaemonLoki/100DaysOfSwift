//
//  ViewController.swift
//  Pairs
//
//  Created by Stefan Blos on 15.11.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var cardContents = [CardContent]()
    var currentlySelectedIndex: Int?
    var takingUserInput = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pairs"
        
        for i in 1...20 {
            cardContents.append(CardContent(textContent: "Item \(i % 10)"))
        }
    }

}

extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardContents.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else {
            fatalError("[cellForItemAt] CollectionViewCell must be a CardCell")
        }
        cell.configure(content: cardContents[indexPath.row].textContent)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else {
            fatalError("[didSelectItemAt] CollectionViewCell must be a CardCell")
        }
        if !cell.isActive { return }
        
        cell.flip()
        
        if let selectedIndex = currentlySelectedIndex {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                if self.cardContents[selectedIndex] == self.cardContents[indexPath.row] {
                    // we have a match, deactivate both cells
                    self.deactivateCell(at: IndexPath(row: selectedIndex, section: 0))
                    self.deactivateCell(at: indexPath)
                } else {
                    // flip both cell back
                    self.flipCell(at: IndexPath(row: selectedIndex, section: 0))
                    self.flipCell(at: indexPath)
                }
                
                // set currently selected to nil
                self.currentlySelectedIndex = nil
            }
        } else {
            currentlySelectedIndex = indexPath.row
        }
    }
    
    private func deactivateCell(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else {
            fatalError("[deactivateCell] Cell not of correct type")
        }
        
        cell.deactivate()
    }
    
    private func flipCell(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else {
            fatalError("[deactivateCell] Cell not of correct type")
        }
        
        cell.flip()
    }
    
}

