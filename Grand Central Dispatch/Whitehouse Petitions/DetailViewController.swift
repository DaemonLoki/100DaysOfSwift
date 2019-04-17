//
//  DetailViewController.swift
//  Whitehouse Petitions
//
//  Created by Stefan Blos on 13.04.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; padding: 1em } </style>
        </head>
        <body>
        <h3>\(detailItem.title)</h3>
        <p>\(detailItem.body)</p>
        <h4>Signatures:</h4>
        <p>\(detailItem.signatureCount) / \(detailItem.signatureThreshold)</p>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }

}
