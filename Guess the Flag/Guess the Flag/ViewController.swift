//
//  ViewController.swift
//  Guess the Flag
//
//  Created by Stefan Blos on 01.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    
    var countries = [String]()
    var score = 0
    var questionsAnswered = 0
    var correctAnswer = 0
    let MAX_QUESTIONS = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
        
        initGame()
        
        askQuestion()
    }
    
    func initGame(action: UIAlertAction! = nil) {
        score = 0
        questionsAnswered = 0
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        questionLabel.text = "Question \(questionsAnswered+1) of \(MAX_QUESTIONS)"
        scoreLabel.text = "Current Score: \(score)"
        
        correctAnswer = Int.random(in: 0...2)
        title = "\(countries[correctAnswer].uppercased())"
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var answerString = ""
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
            answerString = "That's the flag of \(countries[sender.tag].uppercased()).\n"
        }
        
        questionsAnswered += 1
        
        if questionsAnswered >= MAX_QUESTIONS {
            let ac = UIAlertController(title: "FINAL SCORE", message: "Your final score is \(score)!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart game", style: .default, handler: initGame))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: title, message: answerString +
                "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
    }
    
    @objc func showScore() {
        let scoreStr = "Your current score is \(score)"
        
        let ac = UIAlertController(title: "Current Score", message: scoreStr, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
}

