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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
    }

    @IBAction func importPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func setTopText(_ sender: Any) {
        askForText(at: "top") { [weak self] text in
            self?.topText = text
        }
    }
    
    @IBAction func setBottomText(_ sender: Any) {
        askForText(at: "bottom") { [weak self] text in
            self?.bottomText = text
        }
    }
    
    @objc func shareImage() {
        guard let imageToShare = imageView.image else { return }
        let itemsToShare = [imageToShare]
        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        selectedImage = image
        drawMeme()
    }
    
    func askForText(at position: String, action: @escaping (_ selectedText: String) -> ()) {
        let ac = UIAlertController(title: "Enter text to be shown at the \(position):", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let showAction = UIAlertAction(title: "Show", style: .default) { [unowned ac, weak self] _ in
            guard let textField = ac.textFields?[0] else { return }
            guard let text = textField.text else { return }
            
            action(text)
            self?.drawMeme()
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        ac.addAction(showAction)
        
        present(ac, animated: true)
    }
    
    func drawMeme() {
        guard let selectedImage = selectedImage else { return }
        let renderer = UIGraphicsImageRenderer(size: selectedImage.size)
        
        let image = renderer.image { (ctx) in
            selectedImage.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSMutableAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            if !topText.isEmpty {
                let attributedTopText = NSMutableAttributedString(string: topText, attributes: attrs)
                attributedTopText.draw(with: CGRect(x: 0, y: 20, width: selectedImage.size.width, height: 40), options: .usesLineFragmentOrigin, context: nil)
            }
            
            if !bottomText.isEmpty {
                let attributedBottomText = NSMutableAttributedString(string: bottomText, attributes: attrs)
                attributedBottomText.draw(with: CGRect(x: 0, y: selectedImage.size.height - 60, width: selectedImage.size.width, height: 40), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        imageView.image = image
    }
    
}

