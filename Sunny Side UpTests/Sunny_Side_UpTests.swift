//
//  Sunny_Side_UpTests.swift
//  Sunny Side UpTests
//
//  Created by Blair Myers on 1/23/21.
//  Copyright © 2021 Blair Myers. All rights reserved.
//

import XCTest
@testable import Sunny_Side_Up

class CurrentWeatherControllerTests: XCTestCase {
    
    
    let currentWeather = CurrentWeatherViewController()
    
    func testDateFormatter() {
        let date1 = Date(timeIntervalSinceReferenceDate: -123456789.0)
        let result1 = currentWeather.formatDate(date: date1)
        XCTAssert(result1 == "Sat, 2/1")
        let date2 = Date(timeIntervalSinceReferenceDate: 978307199)
        let result2 = currentWeather.formatDate(date: date2)
        XCTAssert(result2 == "Thu, 1/1")
    }
}

class GetWeatherTests: XCTestCase {
    
    let weatherGetter = GetWeather()
    
    func testGetWeather() {
        weatherGetter.getWeather(lat: 300.0, lon: 300.0) {
            result in
            XCTAssert(result.main == nil)
        }
        
        weatherGetter.getWeather(lat: 90.0, lon: 90.0) {
            result in
            XCTAssert(result.main != nil)
        }
        
        weatherGetter.getForecast(city: "abcdefg") {
            result in
            XCTAssert(result.list?[0].dt == nil)
        }
        
        weatherGetter.getForecast(city: "Detroit") {
            result in
            XCTAssert(result.list?[0].dt != nil)
        }
    }
}
