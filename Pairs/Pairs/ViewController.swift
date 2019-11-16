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
    var pairsToMatch = 10
    var cardShowDelay = 0.0
    let delayDiff = 0.08
        
    let numberOfCards = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pairs"
        
        loadCardContents(for: "Capitals")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Switch Topic", style: .plain, target: self, action: #selector(showTopicSheet(_:)))
    }
    
    @objc func showTopicSheet(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Select Topic", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Capitals", style: .default, handler: { [weak self] (_) in
            self?.loadCardContents(for: "Capitals", reloadGame: true)
        }))
        ac.addAction(UIAlertAction(title: "Superheroes", style: .default, handler: { [weak self] (_) in
            self?.loadCardContents(for: "Superheroes", reloadGame: true)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        present(ac, animated: true)
    }
    
    func loadCardContents(for topic: String, reloadGame: Bool = false) {
        title = "Pairs - \(topic)"
        
        let topicCards = Topics.topic(named: topic)
        guard let cards = topicCards else { fatalError("Topic is not available") }
        
        cardContents.removeAll()
        for (i, card) in cards.enumerated() {
            cardContents.append(CardContent(textContent: card.0, index: i))
            cardContents.append(CardContent(textContent: card.1, index: i))
        }
        
        cardContents.shuffle()
        
        if reloadGame {
            reloadGameUI()
        }
    }
    
    private func reloadGameUI() {
        pairsToMatch = 10
        cardShowDelay = 0.0
        takingUserInput = true
        collectionView.reloadData()
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
        cell.configure(content: cardContents[indexPath.row].textContent, delayedBy: cardShowDelay)
        cardShowDelay += delayDiff
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else {
            fatalError("[didSelectItemAt] CollectionViewCell must be a CardCell")
        }
        if !cell.isActive || !takingUserInput || indexPath.row == currentlySelectedIndex { return }
        
        cell.flip()
        
        if let selectedIndex = currentlySelectedIndex {
            takingUserInput = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                if self.cardContents[selectedIndex].index == self.cardContents[indexPath.row].index {
                    // we have a match, deactivate both cells
                    self.deactivateCell(at: IndexPath(row: selectedIndex, section: 0))
                    self.deactivateCell(at: indexPath)
                    
                    self.pairsToMatch -= 1
                    
                    if self.pairsToMatch == 0 {
                        let ac = UIAlertController(title: "Congratulations!", message: "You solved all pairs. Well done!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        
                        self.present(ac, animated: true)
                        self.currentlySelectedIndex = nil
                        return
                    }
                } else {
                    // flip both cell back
                    self.flipCell(at: IndexPath(row: selectedIndex, section: 0))
                    self.flipCell(at: indexPath)
                }
                
                // set currently selected to nil
                self.currentlySelectedIndex = nil
                self.takingUserInput = true
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

