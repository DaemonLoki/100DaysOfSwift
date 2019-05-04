//
//  ViewController.swift
//  Storm Viewer
//
//  Created by Stefan Blos on 31.03.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendApp))
        
        DispatchQueue.global().async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    self?.pictures.append(item)
                }
            }
            self?.pictures.sort()
            
            DispatchQueue.main.async { [weak self] in
                //self?.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
                self?.collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as? PictureCell else {
            fatalError("Unable to dequeue PictureCell.")
        }
        let imageName = pictures[indexPath.row]
        cell.imageName.text = imageName
        cell.imageView.image = UIImage(named: pictures[indexPath.row])
        print("Image '\(imageName)' cell was clicked \(self.getCountFor(imageName: imageName)) times so far")
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageName = pictures[indexPath.row]
        let currentCount = getCountFor(imageName: imageName)
        self.writeCountFor(imageName: imageName, newCount: currentCount + 1)
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailVC.selectedImage = imageName
            detailVC.imagePosition = indexPath.row + 1
            detailVC.numberOfImages = pictures.count
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func getCountFor(imageName name: String) -> Int {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: name) as? Int ?? 0
    }
    
    func writeCountFor(imageName name: String, newCount count: Int) {
        let defaults = UserDefaults.standard
        defaults.set(count, forKey: name)
    }
    
    /* Comment out UITableView code because we temporarily migrated it to UICollectionView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailVC.selectedImage = pictures[indexPath.row]
            detailVC.imagePosition = indexPath.row + 1
            detailVC.numberOfImages = pictures.count
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
 
     */

    @objc func recommendApp() {
        let recommendation = "Who doesn't like storms? If you're like me, this app will take your heart by storm! Please download it and help it storm to the top of the app charts!"
        
        let vc = UIActivityViewController(activityItems: [recommendation], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
}

