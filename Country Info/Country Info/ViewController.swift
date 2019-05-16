//
//  ViewController.swift
//  Country Info
//
//  Created by Stefan Blos on 16.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        
        guard let path = Bundle.main.path(forResource: "flag-data", ofType: "json") else {
            fatalError("Couldn't find path to countries data!")
        }
        
        let flagFileUrl = URL(fileURLWithPath: path)
        
        guard let data = try? Data(contentsOf: flagFileUrl) else {
            fatalError("Couldn't find countries data!")
        }
        
        let decoder = JSONDecoder()
        do {
            countries = try decoder.decode([Country].self, from: data)
        } catch {
            print("Error during decoding of country file!")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Country") as? CountryCell else {
            return UITableViewCell()
        }
        
        let country = countries[indexPath.row]
        cell.flagImageView.image = UIImage(named: country.path)
        cell.countryName.text = country.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else {
            print("Error")
            return
        }
        
        vc.country = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

