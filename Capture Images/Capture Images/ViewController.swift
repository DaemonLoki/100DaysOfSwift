//
//  ViewController.swift
//  Capture Images
//
//  Created by Stefan Blos on 05.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var capturedImages = [CapturedImage]()
    let CELL_ID = "CapturedImageCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Captured Items"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImageSelected))
        
        load()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let capturedImage = capturedImages[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? CapturedImageCell {
            cell.nameLabel.text = capturedImage.name
            let path = getDocumentsDirectory().appendingPathComponent(capturedImage.image)
            cell.capturedImageView.image = UIImage(contentsOfFile: path.path)
            return cell
        } else {
            fatalError("Wrong cell loaded")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return capturedImages.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let capturedImage = capturedImages[indexPath.row]
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailVC.itemTitle = capturedImage.name
            let path = getDocumentsDirectory().appendingPathComponent(capturedImage.image)
            detailVC.imageName = path.path
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    @objc func addImageSelected() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let ac = UIAlertController(title: "Please enter the name of the item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak ac, weak self, imageName] (action) in
            guard let itemName = ac?.textFields?[0].text else { return }
            
            let capturedImage = CapturedImage(image: imageName, name: itemName)
            self?.capturedImages.insert(capturedImage, at: 0)
            self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self?.save()
        }))
        dismiss(animated: true)
        present(ac, animated: true)
        
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        DispatchQueue.global().async { [weak self] in
            let jsonEncoder = JSONEncoder()
            if let savedData = try? jsonEncoder.encode(self?.capturedImages) {
                let defaults = UserDefaults.standard
                defaults.set(savedData, forKey: "capturedImages")
            } else {
                print("Failed to save capturedImages")
            }
        }
    }
    
    func load() {
        DispatchQueue.global().async { [weak self] in
            let defaults = UserDefaults.standard
            if let savedCapturedImages = defaults.object(forKey: "capturedImages") as? Data {
                let decoder = JSONDecoder()
                do {
                    self?.capturedImages = try decoder.decode([CapturedImage].self, from: savedCapturedImages)
                    self?.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
                } catch {
                    print("Failed to load capturedImages")
                }
            }
        }
        
    }

}

