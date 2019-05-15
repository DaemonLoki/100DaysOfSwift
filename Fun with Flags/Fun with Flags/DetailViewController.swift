//
//  DetailViewController.swift
//  Fun with Flags
//
//  Created by Stefan Blos on 03.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var country: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = country?.uppercased() ?? "Flag"
        
        if let country = country {
            imageView.image = UIImage(named: country.lowercased())
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playImageAnimaition(recognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareClicked))
    }
    
    @objc func playImageAnimaition(recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (true) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: [], animations: {
                self.imageView.transform = .identity
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        //navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        //navigationController?.hidesBarsOnTap = false
    }

    @objc func shareClicked() {
        guard let country = country, let image = imageView.image else {
            print("Couldn't find country!")
            return
        }
        let shareStr = "Did you know that \(country.uppercased()) is an awesome country?"
        let vc = UIActivityViewController(activityItems: [image, shareStr], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
}
