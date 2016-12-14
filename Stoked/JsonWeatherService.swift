//
//  JsonWeatherService.swift
//  Stoked
//
//  Created by Thomas Rasmussen on 16/11/2016.
//  Copyright © 2016 Thomas Rasmussen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// class the provides wheaterdata
class JsonWeatherService {
    
    // Method that retrives the weatherdata from a location by a specific search
    func getWeatherForLocation(id: Int , completion: @escaping (JSON) -> ()) {
        
        // GET
        Alamofire.request("http://stokedwebapi.azurewebsites.net/api/weatherapi/\(id)", method: .get)
            .validate()
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                completion(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
