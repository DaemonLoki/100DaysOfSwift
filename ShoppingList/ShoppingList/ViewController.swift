//
//  ViewController.swift
//  ShoppingList
//
//  Created by Stefan Blos on 10.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let cellID = "Item"
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddAlert))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        navigationItem.rightBarButtonItems = [addButton, shareButton]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }

    @objc func showAddAlert() {
        let ac = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] (action) in
            guard let itemName = ac?.textFields?[0].text else {
                return
            }
            self?.shoppingList.insert(itemName, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .right)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    @objc func clearList() {
        let ac = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] (action) in
            let itemCount = self?.shoppingList.count ?? 0
            for _ in 0..<itemCount {
                self?.shoppingList.remove(at: 0)
                self?.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .right)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    
    @objc func shareTapped() {
        let shoppingListString = shoppingList.joined(separator: "\n")
        
        let vc = UIActivityViewController(activityItems: [shoppingListString], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[1]
        present(vc, animated: true)
    }

}

