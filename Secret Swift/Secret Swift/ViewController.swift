//
//  ViewController.swift
//  Secret Swift
//
//  Created by Stefan Blos on 31.10.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var secret: UITextView!
    
    let messageKey = "SecretMessage"
    let passwordKey = "PasswordKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself to the Twitter folks!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed!", message: "You could not be verified. Please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            if let pw = KeychainWrapper.standard.string(forKey: passwordKey) {
                let ac = UIAlertController(title: "Enter password", message: "Please enter the password you previously set.", preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
                ac.addAction(UIAlertAction(title: "Unlock", style: .default, handler: { [weak self] (action) in
                    guard let enteredPw = ac.textFields?[0].text else { return }
                    
                    if pw == enteredPw {
                        self?.unlockSecretMessage()
                    } else {
                        self?.showWrongPassword()
                    }
                }))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "Protect your message", message: "Please enter a password:", preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
                ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] (action) in
                    guard let enteredText = ac.textFields?[0].text else { return }
                    
                    guard let self = self else { return }
                    KeychainWrapper.standard.set(enteredText, forKey: self.passwordKey)
                    self.unlockSecretMessage()
                }))
                present(ac, animated: true)
            }
            let ac = UIAlertController(title: "No biometry available", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveSecretMessage))
        
        secret.text = KeychainWrapper.standard.string(forKey: messageKey) ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: messageKey)
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        
        navigationItem.rightBarButtonItem = nil
    }
    
    func showWrongPassword() {
        let ac = UIAlertController(title: "Wrong password", message: "Password you entered was wrong. Please try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }


}

