//
//  LocationDetailViewController.swift
//  Stoked
//
//  Created by Thomas Rasmussen on 22/11/2016.
//  Copyright © 2016 Thomas Rasmussen. All rights reserved.
//

import UIKit
import SwiftyJSON

// Model for which cell in what index in the table
struct detailCellData {
    let cellId: Int!
    let cellName: String!
}

// LocationDetailController controls the view for the location detail
class LocationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    // Item in the navigation bar
    @IBOutlet weak var locationDetailNavigationItem: UINavigationItem!
    
    // The UIImageView for th background of the view
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // Varible that holds the Weather data
    var json: JSON!
    
    // Varible holding the location data
    var location: LocationModel!
    
    // The TableView holding the tablecells
    @IBOutlet weak var detailTableView: UITableView!
    
    // Array of cellmodels to populate the table
    var arrayOfCellData = [detailCellData]()
    
    // first method that runs
    override func viewDidLoad() {
        // setting up the view
        super.viewDidLoad()
        
        // Setting the name of the location in the detailNavigationBar
        locationDetailNavigationItem.title = location.locationName
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Arial", size: 20)!]
        
        // Setting the backgroundimage
        let image: UIImage!
        image = UIImage(named: "Surf4.Foto-Gjerluff-Photography-1030x686-2")
        backgroundImage.image = image.applyBlurWithRadius(5, tintColor: UIColor(red:0.33, green:0.81, blue:1.00, alpha:0.1), saturationDeltaFactor: 1.8)
        
        // Setting delegate and dataSource to LocationDetailViewController
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        // Array that desides in which order the cells gets loaded into the table
        arrayOfCellData = [detailCellData(cellId: 1, cellName: "description"),
                           detailCellData(cellId: 5, cellName: "bestcondition"),
                           detailCellData(cellId: 2, cellName: "waveforecast"),
                           detailCellData(cellId: 3, cellName: "windforecast"),
                           detailCellData(cellId: 4, cellName: "weatherforecast")]
        
        // removes separatorline from the table
        detailTableView.separatorStyle = .none
    }

    // Number of rows or section in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    // Creates a cell for each table view row depending on the arrayOfCellData
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrayOfCellData[indexPath.row].cellId == 1 {
            let cell = Bundle.main.loadNibNamed("DetailDecriptionCell", owner: self, options: nil)?.first as! DetailDecriptionCell
            
            cell.populateCell(json: json, location: location)
            
            return cell
        } else if arrayOfCellData[indexPath.row].cellId == 2 {
            let cell = Bundle.main.loadNibNamed("WaveForecastCell", owner: self, options: nil)?.first as! WaveForecastCell
            
            cell.populateCell(json: json, location: location)
            
            return cell
        } else if arrayOfCellData[indexPath.row].cellId == 3 {
            let cell = Bundle.main.loadNibNamed("WindForecastCell", owner: self, options: nil)?.first as! WindForecastCell

            cell.populateCell(json: json, location: location)
            
            return cell
        } else if arrayOfCellData[indexPath.row].cellId == 4 {
            let cell = Bundle.main.loadNibNamed("WeatherForecastCell", owner: self, options: nil)?.first as! WeatherForecastCell
            
            cell.populateCell(json: json, location: location)
            
            return cell
        } else if arrayOfCellData[indexPath.row].cellId == 5 && location.isSurfLocation == true {
            let cell = Bundle.main.loadNibNamed("BestConditionsCell", owner: self, options: nil)?.first as! BestConditionsCell
        
            cell.populateCell(json: json, location: location)
        
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("BestConditionsCell", owner: self, options: nil)?.first as! BestConditionsCell
         
            return cell
        }
    }
    
    // Setting the heigh for each rom depending on the custom cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfCellData[indexPath.row].cellId == 1 {
            return 459
        } else if arrayOfCellData[indexPath.row].cellId == 3 {
            return 238
        } else if arrayOfCellData[indexPath.row].cellId == 5 && location.isSurfLocation == true {
            return 238
        } else if arrayOfCellData[indexPath.row].cellId == 2 || arrayOfCellData[indexPath.row].cellId == 4  {
            return 379
        } else {
            return 0
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
