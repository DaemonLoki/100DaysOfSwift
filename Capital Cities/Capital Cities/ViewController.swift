//
//  ViewController.swift
//  Capital Cities
//
//  Created by Stefan Blos on 17.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    let button: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Change View", for: .normal)
        b.backgroundColor = .blue
        b.setTitleColor(.white, for: .normal)
        b.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        b.layer.cornerRadius = 20
        b.addTarget(self, action: #selector(changeViewButtonClicked), for: .touchUpInside)
        b.addTarget(self, action: #selector(outsideOfButtonClicked), for: .touchUpOutside)
        return b
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), link: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), link: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), link: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), link: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), link: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    @objc func changeViewButtonClicked(sender: UIButton) {
        let ac = UIAlertController(title: "Change View of Map:", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: changeViewType))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: changeViewType))
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default, handler: changeViewType))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: changeViewType))
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default, handler: changeViewType))
        present(ac, animated: true)
    }
    
    func changeViewType(action: UIAlertAction) {
        guard let title = action.title else { return }
        
        switch title {
        case "Standard":
            mapView.mapType = .standard
        case "Satellite":
            mapView.mapType = .satellite
        case "Satellite Flyover":
            mapView.mapType = .satelliteFlyover
        case "Hybrid":
            mapView.mapType = .hybrid
        case "Hybrid Flyover":
            mapView.mapType = .hybridFlyover
        default:
            return
        }
    }
    
    @objc func outsideOfButtonClicked(sender: UIView) {
        print("Outside of button clicked")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        (annotationView as? MKPinAnnotationView)?.pinTintColor = .blue
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeLink = capital.link
   
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }
        vc.cityName = placeName
        vc.link = placeLink
        navigationController?.pushViewController(vc, animated: true)
    }

}

