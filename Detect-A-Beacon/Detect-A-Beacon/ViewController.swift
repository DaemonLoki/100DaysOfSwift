//
//  ViewController.swift
//  Detect-A-Beacon
//
//  Created by Stefan Blos on 19.07.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var circleView: UIView!
    
    var locationManager: CLLocationManager?
    
    var noBeaconDetected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        circleView.layer.cornerRadius = 125
        
        view.backgroundColor = .gray
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func showFoundBeaconAlert(major: Int, minor: Int, proximity: Int) {
        let ac = UIAlertController(title: "Beacon detected", message: "Detected beacon with major \(major) and minor \(minor) at proximity \(proximity)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        
        self.present(ac, animated: true)
    }
    
    func update(distance: CLProximity, uuid: String) {
        UIView.animate(withDuration: 1) {
            self.distanceReading.text = uuid
            
            var transformValue: CGFloat
            var newBackgroundColor: UIColor
            
            switch distance {
                
            case .far:
                newBackgroundColor = .blue
                transformValue = 0.25
            case .near:
                newBackgroundColor = .orange
                transformValue = 0.5
            case .immediate:
                newBackgroundColor = .red
                transformValue = 1.0
            default:
                newBackgroundColor = UIColor.gray
                transformValue = 0.1
            }
            self.circleView.backgroundColor = newBackgroundColor
            self.distanceReading.transform = CGAffineTransform(scaleX: transformValue, y: transformValue)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if noBeaconDetected {
                noBeaconDetected = false
                
                self.showFoundBeaconAlert(major: Int(truncating: beacon.major), minor: Int(truncating: beacon.minor), proximity: beacon.proximity.rawValue)
            }
            
            update(distance: beacon.proximity, uuid: beacon.proximityUUID.uuidString)
        } else {
            update(distance: .unknown, uuid: "Unknown")
        }
    }

}

