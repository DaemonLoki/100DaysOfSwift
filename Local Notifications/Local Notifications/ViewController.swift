//
//  ViewController.swift
//  Local Notifications
//
//  Created by Stefan Blos on 10.07.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    let alarmIdentifier = "alarm"
    
    let dayInterval: TimeInterval = 86400
    
    let registerWeeklongAlertsButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Register Daily Alerts", for: .normal)
        b.addTarget(self, action: #selector(registerWeeklongNotifications), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        view.addSubview(registerWeeklongAlertsButton)
        
        NSLayoutConstraint.activate([
            registerWeeklongAlertsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerWeeklongAlertsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let request = createNotificationRequest(timeInterval: 5)
        registerNotificationWith(request: request)
    }
    
    @objc func registerWeeklongNotifications() {
        for i in 1...7 {
            let request = createNotificationRequest(timeInterval: TimeInterval(i) * dayInterval)
            registerNotificationWith(request: request)
        }
    }
    
    func registerNotificationWith(request: UNNotificationRequest) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        center.add(request)
    }
    
    func createNotificationRequest(timeInterval: TimeInterval) ->UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = alarmIdentifier
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        return UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let mute = UNNotificationAction(identifier: "mute", title: "I have seen it", options: .destructive)
        let later = UNNotificationAction(identifier: "later", title: "Remind me later", options: .destructive)
        let category = UNNotificationCategory(identifier: alarmIdentifier, actions: [show, mute, later], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                showAlertControllerWith(title: "Default identifier", message: "You opened the notification with the default identifier")
            case "show":
                showAlertControllerWith(title: "Showing more information", message: "You want more information? Elephants can't jump!")
            case "later":
                let request = self.createNotificationRequest(timeInterval: 86400)
                registerNotificationWith(request: request)
                print("registered notification request")
            case "mute":
                print("muted")
                showAlertControllerWith(title: "Mute", message: "Mute it like it's hot!")
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    func showAlertControllerWith(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(ac, animated: true)
    }

}

