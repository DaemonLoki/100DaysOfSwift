//
//  ViewController.swift
//  Hangman
//
//  Created by Stefan Blos on 18.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var letterButtons = [UIButton]()
    var searchWord = [String]()
    var realWord = "Bahnhof"
    var allWords = ["Bahnhof", "Autobahn", "Gegenfahrbahn", "Parlament"]
    var remainingGuesses = 0 {
        didSet {
            remainingGuessesLabel.text = "Remaining Guesses: \(remainingGuesses)"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .black)
        label.text = "Score: 0"
        return label
    }()
    
    var wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        return label
    }()
    
    var remainingGuessesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    
    var buttonsView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        // add subviews
        view.addSubview(scoreLabel)
        view.addSubview(wordLabel)
        view.addSubview(remainingGuessesLabel)
        view.addSubview(buttonsView)
        
        wordLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20.0),
            scoreLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20.0),
            
            wordLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 40.0),
            wordLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            remainingGuessesLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20.0),
            remainingGuessesLabel.centerXAnchor.constraint(equalTo: wordLabel.centerXAnchor),
            
            buttonsView.topAnchor.constraint(equalTo: remainingGuessesLabel.bottomAnchor, constant: 40.0),
            buttonsView.centerXAnchor.constraint(equalTo: wordLabel.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 400),
            buttonsView.heightAnchor.constraint(equalToConstant: 480),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -40.0)
        ])
        
        let width = 80
        let height = 80
        
        var r = (97...122).map({Character(UnicodeScalar($0))})
        for row in 0..<6 {
            for col in 0..<5 {
                if r.count >= 1 {
                    let letterButton = UIButton(type: .system)
                    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                    letterButton.layer.backgroundColor = UIColor.blue.cgColor
                    letterButton.setTitleColor(UIColor.white, for: .normal)
                    letterButton.alpha = 1
                    letterButton.setTitle(String(r.removeFirst()), for: .normal)
                    
                    let frame: CGRect
                    if r.count > 0 {
                        frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                    } else {
                        frame = CGRect(x: 2 * width, y: row * height, width: width, height: height)
                    }
                    letterButton.frame = frame
                    
                    buttonsView.addSubview(letterButton)
                    letterButtons.append(letterButton)
                    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGame()
    }
    
    func loadGame() {
        searchWord = []
        realWord = loadWord()
        for _ in realWord {
            searchWord.append("?")
        }
        
        for button in letterButtons {
            button.backgroundColor = .blue
            button.setTitleColor(.white, for: .normal)
            button.alpha = 1
            button.isUserInteractionEnabled = true
        }
        
        wordLabel.text = searchWord.joined()
        remainingGuesses = 7
    }
    
    func loadWord() -> String {
        var shuffled = allWords.shuffled()
        return shuffled.removeFirst()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        print("\(sender.titleLabel?.text ?? "unknown") tapped")
        
        guard let letter = sender.titleLabel?.text else { return }
        if isLetterInWord(letter: letter) {
            wordLabel.text = searchWord.joined()
            if !searchWord.contains("?") {
                score += 1
                let ac = UIAlertController(title: "Awesome!", message: "You won! Congratulations! Now can you also solve the next one?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "GO", style: .default, handler: { [weak self] (action) in
                    self?.loadGame()
                }))
                present(ac, animated: true)
            }
        } else {
            remainingGuesses -= 1
            if remainingGuesses == 0 {
                let ac = UIAlertController(title: "You lost!", message: "You are out of guesses. Better luck next time!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
                    self?.loadGame()
                }))
                present(ac, animated: true)
            }
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.alpha = 0.0
        })
        /*
        sender.setTitleColor(UIColor.blue, for: .normal)
        sender.backgroundColor = .white
        sender.isUserInteractionEnabled = false
         */
    }
    
    func isLetterInWord(letter: String) -> Bool {
        var inWord = false
        for (i, e) in realWord.lowercased().enumerated() {
            if String(e) == letter {
                inWord = true
                let r_arr = Array(realWord)
                searchWord[i] = String(r_arr[i])
            }
        }
        return inWord
    }


}

