//
//  GetWeather.swift
//  Sunny Side Up
//
//  Created by Blair Myers on 1/23/21.
//  Copyright © 2021 Blair Myers. All rights reserved.
//

import UIKit

class GetWeather {
    
    static let shared = GetWeather()
    
    var latitude: Double?
    var longitude: Double?
    var apiKey = "264d6bdd43e6e2842ad2b21c8d99b563"
    var city: String?
    

    func getWeather(lat: Double, lon: Double, completionHandler: @escaping (_ response: OpenWeatherMapResponse) -> ()) {
        
        let apiUrl = "http://api.openweathermap.org/data/2.5/weather?lat=" + "\(lat)" + "&lon=" + "\(lon)" + "&appid=" + apiKey + "&units=imperial"
            
        // Access API URL
        let task = URLSession.shared.dataTask(with: URL(string: apiUrl)!) {
            data, response, error in
                
            guard let data = data, error == nil else {
                return
            }
                
            var result: OpenWeatherMapResponse?
            do {
                // See if API data corresponds with OpenWeatherMap struct
                result = try JSONDecoder().decode(OpenWeatherMapResponse.self, from: data)
                if let result = result {
                    completionHandler(result)
                }
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
                
            // Make sure we're getting a json response back
            guard result != nil else {
                return
            }
            
            }
                
        task.resume()
    }
    
    func getForecast(city: String, completionHandler: @escaping (_ response: ForecastResponse) -> ()) {
        
        let forecastUrl = "http://api.openweathermap.org/data/2.5/forecast?q=" + city + "&appid=" + apiKey + "&units=imperial"
        
        let task = URLSession.shared.dataTask(with: URL(string: forecastUrl)!) {
                data, response, error in
                
            guard let data = data, error == nil else {
                return
            }
                
            var result: ForecastResponse?
            do {
                result = try JSONDecoder().decode(ForecastResponse.self, from: data)
                if let result = result {
                    completionHandler(result)
                }
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard result != nil else {
                return
            }
            
            }
            
        task.resume()
    }
    
}
