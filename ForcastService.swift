//
//  ForcastService.swift
//  Stormy
//
//  Created by Aaron Monick on 5/30/15.
//

import Foundation

struct ForcastService {
    
    let forcastAPIKey: String
    let forcastBaseURL: NSURL?
    
    
    init(APIKey: String) {
        
        forcastAPIKey = APIKey
        forcastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forcastAPIKey)/")
        
    }
    
    func getForcast(lat: Double, long: Double, completion: (CurrentWeather? -> Void)) {
        
        if let forcastURL = NSURL(string: "\(lat),\(long)", relativeToURL: forcastBaseURL) {
            
            let networkOperation = NetworkOperation(url: forcastURL)
            
            networkOperation.downloadJSONFromURL {
                (let JSONDictionary) in
                let currentWeather = self.currentWeatherFromDictionary(JSONDictionary)
                completion(currentWeather)
            }
            
        } else {
            println("Error: Could not construct a valid URL")
        }
    }

    func currentWeatherFromDictionary(jsonDictionary: [String: AnyObject]?) -> CurrentWeather? {
        
        if let currentWeatherDictionary = jsonDictionary?["currently"] as? [String: AnyObject] {
            
            return CurrentWeather(weatherDictionary: currentWeatherDictionary)
            
        } else {
            println("Error: JSON Dictionary returned nil for currently key")
            return nil
        }
    }


}