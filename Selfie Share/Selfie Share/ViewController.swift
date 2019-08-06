//
//  ViewController.swift
//  Selfie Share
//
//  Created by Stefan Blos on 05.08.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController {
    
    var images = [UIImage]()
    
    var peerId = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mcSession = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        
        title = "Selfie Share"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture)),
            UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeMessage))
        ]
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt)),
            UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showPeers))
        ]
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func composeMessage() {
        let ac = UIAlertController(title: "Send messag", message: "Please enter the message you want to send:", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Send", style: .default, handler: { [unowned ac, weak self] (_) in
            guard let textField = ac.textFields?[0] else { return }
            if let messageToSend = textField.text {
                if messageToSend.isEmpty { return }
                self?.sendMessage(messageToSend)
            }
        }))
    }
    
    func sendMessage(_ message: String) {
        guard let session = mcSession else { return }
        
        if session.connectedPeers.count > 0 {
            let messageData = Data(message.utf8)
            do {
                try session.send(messageData, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                
                present(ac, animated: true)
            }
        }
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        present(ac, animated: true)
    }
    
    @objc func showPeers() {
        guard let session = mcSession else { return }
        
        if session.connectedPeers.count > 0 {
            let peersList = session.connectedPeers.map({ $0.displayName }).joined(separator: "\n")
            let ac = UIAlertController(title: "Connected peers", message: peersList, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(ac, animated: true)
        }
    }
    
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }

}

extension ViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerId.displayName)")
            
        case .connecting:
            print("Connecting: \(peerId.displayName)")
            
        case .notConnected:
            print("Not connected: \(peerId.displayName)")
            let ac = UIAlertController(title: "Disconnected", message: "\(peerId.displayName) has disconnected.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        @unknown default:
            print("Unknown state received: \(peerId.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
                return
            }
            let message = String(decoding: data, as: UTF8.self)
            let ac = UIAlertController(title: "Received message", message: "\(peerID.displayName): \(message)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            self?.present(ac, animated: true)
        }
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // required empty stub
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // required empty stub
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // required empty stub
    }
    
}

extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.row]
        }
        
        return cell
    }
    
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        guard let session = mcSession else { return }
        
        if session.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try session.send(imageData, toPeers: session.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    present(ac, animated: true)
                }
            }
            
        }
    }
    
}

