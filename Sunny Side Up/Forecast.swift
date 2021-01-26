//
//  Forecast.swift
//  Sunny Side Up
//
//  Created by Blair Myers on 1/24/21.
//  Copyright © 2021 Blair Myers. All rights reserved.
//

import UIKit

struct ForecastResponse: Decodable {
    
    struct Main: Decodable {
        let temp: Double?
    }
    
    struct Weather: Decodable {
        let icon: String?
    }
    
    struct List: Decodable {
        let dt: Date?
        let main: Main?
        let weather: [Weather]?
    }
    
    let list: [List]?
}
