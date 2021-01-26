//
//  Weather.swift
//  Sunny Side Up
//
//  Created by Blair Myers on 1/23/21.
//  Copyright © 2021 Blair Myers. All rights reserved.
//

import UIKit

struct OpenWeatherMapResponse: Decodable {
    
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }
    
    struct Main: Decodable {
        let temp: Double?
    }
    
    let main: Main?
}


