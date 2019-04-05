//
//  ViewController.swift
//  Word Scramble
//
//  Created by Stefan Blos on 05.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let textString = try? String(contentsOf: url) {
                allWords = textString.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["Error"]
        }
        
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }


}

