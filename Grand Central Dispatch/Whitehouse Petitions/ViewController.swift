//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Stefan Blos on 11.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shownPetitions = [Petition]()
    var allPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Petitions"
        
        navigationItem.rightBarButtonItems =
            [UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearch)),
             UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Show all", style: .plain, target: self, action: #selector(showAllPetitions))

        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString: String
    
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            //urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            //urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showSearch() {
        let ac = UIAlertController(title: "Search for:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        ac.addAction(UIAlertAction(title: "Go", style: .default, handler: { [weak self, weak ac] (action) in
            guard let searchTerm = ac?.textFields?[0].text else {
                return
            }
            self?.performSelector(inBackground: #selector(self?.performSearchFor(term:)), with: searchTerm)
        }))
        present(ac, animated: true)
    }
    
    @objc func showAllPetitions() {
        shownPetitions = allPetitions
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "All presented data comes from the 'We The People' API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func performSearchFor(term: String) {
        print("Performing search for \(term) on thread: \(Thread.current)")
        let lowerTerm = term.lowercased()
        shownPetitions = allPetitions.filter( {$0.title.lowercased().contains(lowerTerm) || $0.body.lowercased().contains(lowerTerm) } )
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            allPetitions = jsonPetitions.results
            showAllPetitions()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = shownPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = shownPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

