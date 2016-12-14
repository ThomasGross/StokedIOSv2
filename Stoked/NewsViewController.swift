//
//  NewsViewController.swift
//  Stoked
//
//  Created by Thomas Rasmussen on 11/11/2016.
//  Copyright © 2016 Thomas Rasmussen. All rights reserved.
//

import UIKit

// This ViewController controls the News view
class NewsViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var SideMenuButton: UIBarButtonItem!
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        // Setting up the view
        super.viewDidLoad()

        // Setting up the navigation to the manu
        SideMenuButton.target = self.revealViewController()
        SideMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // adding gesturerecongnizer
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Setting up the webview, setting the delagate to self
        // Setting the URL for the webview to load
        webView.delegate = self
        if let url = URL(string: "http://www.dsrf.dk/nyheder/") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
