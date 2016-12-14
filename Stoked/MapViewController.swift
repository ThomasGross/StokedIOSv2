//
//  ViewController.swift
//  Stoked
//
//  Created by Thomas Rasmussen on 10/11/2016.
//  Copyright © 2016 Thomas Rasmussen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

//
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // Outlet for the segmentedcontol filter
    @IBOutlet weak var segmentedControlForAnnotationOutlet: UISegmentedControl!
    
    // Action for the segmentedcontol filter
    @IBAction func segmentedControlForAnnotation(_ sender: UISegmentedControl) {
        switch segmentedControlForAnnotationOutlet.selectedSegmentIndex
        {
        case 0:
            sortAnnotations(type: 0)
        case 1:
            sortAnnotations(type: 1)
        case 2:
            sortAnnotations(type: 2)
        case 3:
            sortAnnotations(type: 3)
        default:
            break;
        }
    }

    // The reference to the ActivityIndicator view
    @IBOutlet weak var locationActivityIndicator:UIActivityIndicatorView!
    
    // Refrence to the menu navigation button
    @IBOutlet weak var SideMenuButton: UIBarButtonItem!
    
    // refrence to the mapview in the storyboard
    @IBOutlet weak var MapView: MKMapView!
    
    // refrence to the calloutbutton View
    @IBOutlet weak var calloutButton: UIButton!
    
    // Action on the callout button
    @IBAction func calloutbuttonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToDetailView", sender: self)
    }
    
    // Tells whether or not to update userlocation
    var relocation : Bool = false
    
    // Delegate property for the locationmanager
    var locationManager = CLLocationManager()
    
    // The instance of the service enables getting the location
    var jsonLocationService = JsonLocationService()
    
    // The instance of the service enables getting the weather
    var jsonWeatherService = JsonWeatherService()
    
    // array holding all locations
    var locations: [LocationModel] = []
    
    // variable holding a temporary weather objekt
    var tempCalloutLocation: JSON?
    
    // variable holding a temporary location objekt
    var tempLocation: LocationModel?
    
    // fist method the controller runs
    override func viewDidLoad() {
        // setting up the view
        super.viewDidLoad()

        // Setting up the navigation to the manu
        SideMenuButton.target = self.revealViewController()
        SideMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        getAnnotations()
        
        // sets the delegate to be self
        locationManager.delegate = self
        
        // sets the delegate to be self
        MapView.delegate = self
        
        // set the disired location to be best possible
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // We only want to use locationmanager when the app is used
        locationManager.requestWhenInUseAuthorization()
    }
    
    // method that runs when the view appears
    override func viewDidAppear(_ animated: Bool) {
        if relocation == true {
            locationManager.startUpdatingLocation()
            
        }
    }
    
    // method that is called when the application authorizesation is changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            
            // method that start looking for a location
            locationManager.startUpdatingLocation()
            print("started updating map")
            MapView.showsUserLocation = true
            relocation = true
            
            
        default:
            locationManager.stopUpdatingLocation()
            print("stopped updating map")
            MapView.showsUserLocation = false
        }
    }
    
    // If the locationmanager did update loactions this method is called
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get the last updated location
        if let userLocation = locations.last{
            
            // sets the region of the screen
            let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate,100000,100000)
            self.MapView.setRegion(region, animated: true)
            
            MapView.showsUserLocation = true
        }
        
        if relocation{
            locationManager.stopUpdatingLocation()
            relocation = false
        }
        
    }
    
    // sorts the locations depending on user input
    func sortAnnotations(type: Int) {
        self.MapView.removeAnnotations(MapView.annotations)
        
        if type == 0{
            addAnnotations()
        } else {
            
            for location in locations where location.showLocation == true{
                
                if location.isSurfLocation == true && type == 1 {
                    addSpecificAnnotation(location: location)
                }
                else if location.isSUPLocation == true && type == 2 {
                    addSpecificAnnotation(location: location)
                }
                else if location.isWhiteWaterLocation == true && type == 3 {
                    addSpecificAnnotation(location: location)
                } else  {
                    print("")
                }
            }
        }
    }
    
    // method the is called to get locations from location service
    func getAnnotations() {
        
        locationActivityIndicator.startAnimating()
        
        DispatchQueue.main.async {
            self.jsonLocationService.getLocations() { responceLocation in
                self.locations = responceLocation
                
                self.addAnnotations()
                
                self.locationActivityIndicator.stopAnimating()
                self.locationActivityIndicator.isHidden = true
            }
        }
        
    }
    
    // adds all location to the mapview
    func addAnnotations (){
        
        // loops though the list of mapitems in the response
        for location in self.locations where location.showLocation == true {
            
            let customAnnotation = CustomAnnotationModel()
            
            let locationCordinate = CLLocationCoordinate2D(latitude: location.locationLat, longitude: location.locationLong)
            customAnnotation.locationId = location.locationId
            customAnnotation.coordinate = locationCordinate // assign cordinate to the annotation
            
            self.MapView.addAnnotation(customAnnotation) // add the annotation to the map
            
        }
    }
    
    // add one specific annotation to the map
    func addSpecificAnnotation (location: LocationModel){
        
        let customAnnotation = CustomAnnotationModel()
        
        let locationCordinate = CLLocationCoordinate2D(latitude: location.locationLat, longitude: location.locationLong)
        customAnnotation.locationId = location.locationId
        customAnnotation.coordinate = locationCordinate // assign cordinate to the annotation
        
        self.MapView.addAnnotation(customAnnotation) // add the annotation to the map
        
    }
    
    // Method that sets up the annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin") as? CustomAnnotationViewModel
        
        if annotationView == nil{
            
            annotationView = CustomAnnotationViewModel(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
            
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "location30x30_GreenColor2")
        return annotationView
    }

    
    // called when user selects an annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // the method will check whether the selected annotation is a user location related annotation, in this case, it will return without doing anything.
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        
        // setting up custom annotationView
        let customAnnotation = view.annotation as! CustomAnnotationModel
        
        locationActivityIndicator.startAnimating()
        locationActivityIndicator.isHidden = false
        
        // loops though allle location to get specific location by id
        for location in locations {
            if location.locationId == customAnnotation.locationId  {
                
                tempLocation = location
                
                // Runs a new thead
                DispatchQueue.main.async {
                    
                    // Get weather data for lacation
                    self.jsonWeatherService.getWeatherForLocation(id: location.locationId) { responceLocation in
                        
                        self.locationActivityIndicator.stopAnimating()
                        self.locationActivityIndicator.isHidden = true
                        
                        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
                        let calloutView = views?[0] as! CustomCalloutView
                        
                        
                        calloutView.getlocationDetails(location: location, json: responceLocation)
                        
                        self.tempCalloutLocation = responceLocation
                        
                        
                        self.calloutButton.isHidden = false
                        
                        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
                        
                        view.addSubview(calloutView)
                        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
                        
                    }
                }
            }
        }
        
    }
    
    // Method that runs when a user deselects a annotation
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        // removes the calloutview from the user sceen
        if view.isKind(of: CustomAnnotationViewModel.self)
        {
            for subview in view.subviews
            {
                self.calloutButton.isHidden = true
                subview.removeFromSuperview()
            }
        }
    }
    
    // method that is call when the region on the application is changed
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {

        if animated == false {
            self.calloutButton.isHidden = true
            
        }else {
            
        }
        
    }
    
    // Method that transfers data to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetailView" {
            if let vc = segue.destination as? LocationDetailViewController {
                vc.json = tempCalloutLocation
                vc.location = tempLocation
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationController?.navigationBar.tintColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1.0)
                
                navigationItem.backBarButtonItem = backItem
                // to set image:
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
