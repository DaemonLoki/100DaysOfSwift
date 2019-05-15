//
//  ViewController.swift
//  Instafilter
//
//  Created by Stefan Blos on 07.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var radius: UISlider!
    @IBOutlet var scale: UISlider!
    
    
    @IBOutlet var changeFilterButton: UIButton!
    
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Core Image Filters FTW"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
        imageView.image = image
        imageView.alpha = 0.0
        
        perform(#selector(fadeInImageView), with: nil, afterDelay: 0)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        setFilterOptions()
        applyProcessing()
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        
        guard let actionTitle = action.title else { return }
        changeFilterButton.setTitle(actionTitle, for: .normal)
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        setFilterOptions()
        
        applyProcessing()
    }
    
    func setFilterOptions() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            setValueForFilter(key: kCIInputIntensityKey, to: intensity.value)
            intensity.isEnabled = true
        } else {
            intensity.isEnabled = false
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            setValueForFilter(key: kCIInputRadiusKey, to: radius.value * 200)
            radius.isEnabled = true
        } else {
            radius.isEnabled = false
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            setValueForFilter(key: kCIInputScaleKey, to: scale.value * 10)
            scale.isEnabled = true
        } else {
            scale.isEnabled = false
        }
    }
    
    func setValueForFilter(key: String, to value: Any) {
        currentFilter.setValue(value, forKey: key)
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width/2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        guard let image = currentFilter.outputImage else { return }
        if let cgImg = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgImg)
            imageView.image = processedImage
        }
    }
    
    @objc func fadeInImageView() {
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.imageView.alpha = 1.0
        }, completion: nil)
    }

    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Error", message: "Couldn't find an image to save. Please add one first by clicking the '+' button in the upper right.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image was saved to photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        setValueForFilter(key: kCIInputIntensityKey, to: intensity.value)
        applyProcessing()
    }
    
    @IBAction func scaleChanged(_ sender: Any) {
        setValueForFilter(key: kCIInputScaleKey, to: scale.value * 10)
        applyProcessing()
    }
    
    @IBAction func radiusChanged(_ sender: Any) {
        setValueForFilter(key: kCIInputRadiusKey, to: radius.value * 200)
        applyProcessing()
    }
    
}

