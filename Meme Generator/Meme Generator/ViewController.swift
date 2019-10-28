//
//  ViewController.swift
//  Meme Generator
//
//  Created by Stefan Blos on 28.10.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: UIImage?
    var topText: String = ""
    var bottomText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
    }

    @IBAction func importPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func setTopText(_ sender: Any) {
    }
    
    @IBAction func setBottomText(_ sender: Any) {
    }
    
    @objc func shareImage() {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        selectedImage = image
        drawMeme()
    }
    
    func drawMeme() {
        guard let selectedImage = selectedImage else { return }
        let renderer = UIGraphicsImageRenderer(size: selectedImage.size)
        
        let image = renderer.image { (ctx) in
            selectedImage.draw(at: CGPoint(x: 0, y: 0))
        }
        
        imageView.image = image
    }
    
}

