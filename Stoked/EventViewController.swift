//
//  ViewController.swift
//  Stoked
//
//  Created by Thomas Rasmussen on 11/11/2016.
//  Copyright © 2016 Thomas Rasmussen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// EventViewController controls the Events view
class EventViewController: UIViewController, UIWebViewDelegate {

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
