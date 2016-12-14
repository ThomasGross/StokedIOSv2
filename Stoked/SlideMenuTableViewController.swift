//
//  SlideMenuTableViewController.swift
//  Stoked
//
//  Created by Thomas Rasmussen on 10/11/2016.
//  Copyright © 2016 Thomas Rasmussen. All rights reserved.
//

import UIKit
import Foundation

// model for the cell data
struct cellData {
    let cellId: Int!
    let text: String!
    let image: UIImage!
}

class SlideMenuTableViewController: UITableViewController {
    
    // array that holds the celldata
    var arrayOfCellData = [cellData]()
    
    // fist method that is called
    override func viewDidLoad() {
        // setting up the array
        arrayOfCellData = [cellData(cellId: 1, text: "", image:  #imageLiteral(resourceName: "StokedLogoResize")),
                           cellData(cellId: 2, text: "Locations", image: #imageLiteral(resourceName: "LocationsLogo")),
                           cellData(cellId: 2, text: "Events", image: #imageLiteral(resourceName: "eventsLogo")),
                           cellData(cellId: 2, text: "Newsfeed", image: #imageLiteral(resourceName: "newsLogo")),]
        
        
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Sets up number of row or sections in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }


    // Sets up a cell for each index depending on id from arrayOfCellData
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfCellData[indexPath.row].cellId == 1 {
            let cell = Bundle.main.loadNibNamed("SlideMenuTopCell", owner: self, options: nil)?.first as! SlideMenuTopCell
            
            cell.stokedLogo.image = arrayOfCellData[indexPath.row].image
            
            return cell
        } else if arrayOfCellData[indexPath.row].cellId == 2 {
            let cell = Bundle.main.loadNibNamed("SlideMenuItemCell", owner: self, options: nil)?.first as! SlideMenuItemCell
            
            cell.cellImage.image = arrayOfCellData[indexPath.row].image
            cell.cellLabel.text = arrayOfCellData[indexPath.row].text
            
            return cell
            
        } else {
        
            let cell = Bundle.main.loadNibNamed("SlideMenuItemCell", owner: self, options: nil)?.first as! SlideMenuItemCell
            
            return cell
        }
    }
    
    // Sets up the heigt for each index in the table depending on the id from arrayOfCellData
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfCellData[indexPath.row].cellId == 1 {
            return 140
        } else if arrayOfCellData[indexPath.row].cellId == 2 {
            return 54
        } else {
            return 54
        }
        
    }
    
    // method that is called when the user clicks a cell, hereby performing a segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrayOfCellData[indexPath.row].cellId != 1 {
            if arrayOfCellData[indexPath.row].text == "Locations" {
                performSegue(withIdentifier: "segueToMapView", sender: self)
                
            } else if arrayOfCellData[indexPath.row].text == "Events" {
                performSegue(withIdentifier: "segueToEventView", sender: self)
                
            } else if arrayOfCellData[indexPath.row].text == "Newsfeed" {
                performSegue(withIdentifier: "segueToNewsView", sender: self)
            }
            
        }
    }
    
    // Setting up the mapViewControllers relocation to be true, which in turn makes it possible to zoom in on the users location after performing a segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMapView" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController
            
            if let vc = targetController as? MapViewController {
                
                vc.relocation = true
                
            }
        }
    }
}
