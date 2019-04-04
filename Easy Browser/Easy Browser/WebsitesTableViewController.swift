//
//  WebsitesTableViewController.swift
//  Easy Browser
//
//  Created by Stefan Blos on 04.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class WebsitesTableViewController: UITableViewController {
    
    var websites = ["apple.com", "hackingwithswift.com"]
    let CELL_ID = "WebsiteCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Websites"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? ViewController{
            detailVC.website = websites[indexPath.row]
            detailVC.websites = websites
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
