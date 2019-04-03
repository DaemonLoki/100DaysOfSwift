//
//  ViewController.swift
//  Fun with Flags
//
//  Created by Stefan Blos on 03.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Fun with Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        /* load from json later
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        */
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Flag") else {
            return UITableViewCell()
        }
        
        // set image
        let imagePath = countries[indexPath.row]
        cell.imageView?.image = UIImage(named: imagePath + ".png")
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.imageView?.layer.cornerRadius = 3.0
        cell.imageView?.clipsToBounds = true
        
        // set text
        cell.textLabel?.text = imagePath.uppercased()
        return cell
    }


}

