//
//  DetailViewController.swift
//  Capital Cities
//
//  Created by Stefan Blos on 18.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var cityName: String?
    var link: String?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = cityName {
            title = name
        }

        guard let link = link, let url = URL(string: link) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
