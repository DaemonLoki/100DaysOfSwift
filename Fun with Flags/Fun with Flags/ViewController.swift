//
//  ViewController.swift
//  Fun with Flags
//
//  Created by Stefan Blos on 03.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var flags = [Flag]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Fun with Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let path = Bundle.main.path(forResource: "flag-data", ofType: "json") else {
            print("Couldn't find flag data!")
            return
        }
        
        let flagFileURL = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: flagFileURL) else {
            print("Data could not be loaded from URL")
            return
        }
        let decoder = JSONDecoder()
        
        do {
            flags = try decoder.decode([Flag].self, from: data)
        } catch {
            print("Error during decoding of Flag file")
        }
    
        /*
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        */
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Flag") else {
            return UITableViewCell()
        }
        
        // set image
        let flag = flags[indexPath.row]
        cell.imageView?.image = UIImage(named: flag.path + ".png")
        cell.imageView?.layer.borderWidth = 1
        let colorValue: CGFloat = 241.0/255.0
        cell.imageView?.layer.borderColor = UIColor(red: colorValue, green: colorValue, blue: colorValue, alpha: 1.0).cgColor
        cell.imageView?.layer.cornerRadius = 3.0
        cell.imageView?.clipsToBounds = true
        
        // set text
        cell.textLabel?.text = flag.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else {
            print("Error!")
            return
        }
        
        vc.country = flags[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }


}

