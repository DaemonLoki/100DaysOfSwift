//
//  DetailViewController.swift
//  Country Info
//
//  Created by Stefan Blos on 16.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let SIDE_MARGIN: CGFloat = 20
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.bounces = true
        return v
    }()
    
    let flagImageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let transparentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .darkGray
        v.alpha = 0.3
        return v
    }()
    
    let nameLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        v.textColor = .white
        return v
    }()
    
    let capitalTitle = DetailViewController.createTitleLabel(with: "Capital")
    let capitalLabel = DetailViewController.createContentLabel(with: "---")
    
    let demonymTitle = DetailViewController.createTitleLabel(with: "Demonym")
    let demonymLabel = DetailViewController.createContentLabel(with: "---")
    
    let nativeNameTitle = DetailViewController.createTitleLabel(with: "Native name")
    let nativeNameLabel = DetailViewController.createContentLabel(with: "---")
    
    let populationTitle = DetailViewController.createTitleLabel(with: "Population")
    let populationLabel = DetailViewController.createContentLabel(with: "---")
    
    let areaTitle = DetailViewController.createTitleLabel(with: "Area")
    let areaLabel = DetailViewController.createContentLabel(with: "---")
    
    let subregionTitle = DetailViewController.createTitleLabel(with: "Subregion")
    let subregionLabel = DetailViewController.createContentLabel(with: "---")
    
    let languagesTitle = DetailViewController.createTitleLabel(with: "Languages")
    let languagesLabel = DetailViewController.createContentLabel(with: "---")
    
    let currenciesTitle = DetailViewController.createTitleLabel(with: "Currencies")
    let currenciesLabel = DetailViewController.createContentLabel(with: "---")
    
    var country: Country?
    var countryInfo: CountryInfo?
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(flagImageView)
        scrollView.addSubview(transparentView)
        scrollView.addSubview(nameLabel)
        
        let textViews = [
            capitalTitle, capitalLabel, demonymTitle, demonymLabel, nativeNameTitle, nativeNameLabel, populationTitle, populationLabel, areaTitle, areaLabel, subregionTitle, subregionLabel, languagesTitle, languagesLabel, currenciesTitle, currenciesLabel
        ]
        
        var previousView: UIView = flagImageView
        for (n,v) in textViews.enumerated() {
            scrollView.addSubview(v)
            v.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: SIDE_MARGIN).isActive = true
            v.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -SIDE_MARGIN).isActive = true
            let distanceToTop: CGFloat = n % 2 == 0 ? 20 : 5
            v.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: distanceToTop).isActive = true
            previousView = v
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            flagImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            flagImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            flagImageView.heightAnchor.constraint(equalTo: flagImageView.widthAnchor, multiplier: 0.5),
            
            transparentView.topAnchor.constraint(equalTo: flagImageView.topAnchor),
            transparentView.leadingAnchor.constraint(equalTo: flagImageView.leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: flagImageView.trailingAnchor),
            transparentView.bottomAnchor.constraint(equalTo: flagImageView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: flagImageView.leadingAnchor, constant: SIDE_MARGIN),
            nameLabel.trailingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: -SIDE_MARGIN),
            nameLabel.bottomAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 60),
            
            currenciesLabel.heightAnchor.constraint(equalToConstant: 40),
            currenciesLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SIDE_MARGIN)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Info"
        
        guard let country = country else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        flagImageView.image = UIImage(named: country.path)
        nameLabel.text = country.name
        
        loadCountryInfo(for: country.link)
    }
    
    func loadCountryInfo(for urlString: String) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    let decoder = JSONDecoder()
                    
                    if let jsonCountryInfo = try? decoder.decode(CountryInfo.self, from: data) {
                        self.countryInfo = jsonCountryInfo
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.populateUI()
                        }
                    }
                }
                
            }
        }
        
    }
    
    func populateUI() {
        guard let countryInfo = self.countryInfo else { return }
        
        self.nativeNameLabel.text = countryInfo.nativeName
        self.capitalLabel.text = countryInfo.capital
        self.demonymLabel.text = countryInfo.demonym
        self.populationLabel.text = "\(countryInfo.population) people"
        self.areaLabel.text = "\(countryInfo.area) km^2"
        self.subregionLabel.text = "\(countryInfo.subregion)"
        self.languagesLabel.text = countryInfo.languages.map({ $0.name }).joined(separator: "\n")
        self.currenciesLabel.text = countryInfo.currencies.map({ $0.symbol + " - " + $0.name }).joined(separator: "\n")
    }
    
    static func createTitleLabel(with title: String) -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        l.textColor = .lightGray
        l.text = title
        return l
    }
    
    static func createContentLabel(with content: String) -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 28, weight: .light)
        l.text = content
        return l
    }

}
