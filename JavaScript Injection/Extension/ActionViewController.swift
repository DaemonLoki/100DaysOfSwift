//
//  ActionViewController.swift
//  Extension
//
//  Created by Stefan Blos on 01.06.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController, InformationDelegate {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var hostName: String?
    
    static let SCRIPTS_KEY = "scripts"
    var scripts = [ScriptObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save)),
            UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(load))
        ]
        
        registerKeyboardObserver()
        
        loadScripts()
    
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    if let urlString = self?.pageURL {
                        let urlForUserDefaults = URL(string: urlString)
                        if let hostName = urlForUserDefaults?.host {
                            self?.hostName = hostName
                            DispatchQueue.global(qos: .default).async {
                                let userDefaults = UserDefaults.standard
                                if let loadedScript = userDefaults.string(forKey: hostName) {
                                    DispatchQueue.main.async {
                                        self?.script.text = loadedScript
                                    }
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    
    func registerKeyboardObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

    @objc func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text as Any]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        if let hostName = self.hostName, let scriptText = script.text {
            DispatchQueue.global(qos: .background).async {
                let defaults = UserDefaults.standard
                defaults.set(scriptText, forKey: hostName)
            }
        }
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func save() {
        let ac = UIAlertController(title: "Enter name:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self, weak ac] (action) in
            if let name = ac?.textFields?[0].text, let code = self?.script.text {
                self?.scripts.append(ScriptObject(name: name, code: code))
                self?.saveScripts()
            }
        }))
        
        present(ac, animated: true)
    }
    
    @objc func load() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Scripts") as? ScriptsTableViewController {
            vc.scripts = self.scripts
            vc.delegate = self
            self.present(vc, animated: true)
            
        }
    }
    
    func saveScripts() {
        DispatchQueue.global(qos: .default).async {
            let userDefaults = UserDefaults.standard
            if let encodedData = try? PropertyListEncoder().encode(self.scripts) {
                userDefaults.set(encodedData, forKey: ActionViewController.SCRIPTS_KEY)
            }
        }
    }
    
    func loadScripts() {
        DispatchQueue.global(qos: .default).async {
            let userDefaults = UserDefaults.standard
            if let data = userDefaults.value(forKey: ActionViewController.SCRIPTS_KEY) as? Data {
                DispatchQueue.main.async {
                    if let loadedScripts = try? PropertyListDecoder().decode(Array<ScriptObject>.self, from: data) {
                        self.scripts = loadedScripts
                    }
                }
            }
        }
    }
    
    func selectedScript(script: ScriptObject) {
        self.script.text = script.code
    }

}
