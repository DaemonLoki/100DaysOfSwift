//
//  ViewController.swift
//  Meme Generator
//
//  Created by Stefan Blos on 28.10.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
    }

    @IBAction func importPicture(_ sender: Any) {
    }
    
    @IBAction func setTopText(_ sender: Any) {
    }
    
    @IBAction func setBottomText(_ sender: Any) {
    }
    
    @objc func shareImage() {
        
    }
    
}

