//
//  CurrentWeatherViewController.swift
//  Sunny Side Up
//
//  Created by Blair Myers on 1/24/21.
//  Copyright © 2021 Blair Myers. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CurrentWeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var loadIndicator: UIActivityIndicatorView!
    @IBOutlet var temperatureView: UIView!
    
    let locationManager = CLLocationManager()
    var location: String = "" {
        didSet {
            locationLabel.text = location
        }
    }
    
    var response: OpenWeatherMapResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Create border around Temperature label
        temperatureView.layer.borderWidth = 5
        temperatureView.layer.borderColor = UIColor.label.cgColor
        temperatureView.layer.cornerRadius = 8
        
        // We should make a new API call each time the user opens the app, so set a notification function willEnterForeground
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    
    }
    
    @objc func willEnterForeground() {
        
        // Make API call and clean up UI
        if temperatureLabel.text == "" {
            loadIndicator.startAnimating()
            loadIndicator.isHidden = false
        }
        
        getLocation()
        dateLabel.text = formatDate(date: Date())
    }
    
    // Display formatted date in top right corner
    func formatDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, M/d"
        
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
    
    // Make API call from GetWeather and update UI
    func getWeather() {
        
        // Make sure lat and lon are initialized
        if let lon = GetWeather.shared.longitude,
           let lat = GetWeather.shared.latitude {
            
            GetWeather.shared.getWeather(lat: lat, lon: lon) {
                result in
                
                // Go back to main thread to update UI
                DispatchQueue.main.async {
                    if let temperature = result.main?.temp {
                        self.loadIndicator.isHidden = true
                        self.loadIndicator.stopAnimating()
                        self.temperatureLabel.text = "\(Int(temperature.rounded()))°"
                    }
                }
            }
        }
    }
    
    func getLocation() {
        
        // Ask for location if user hasn't already authorized. Then get lat, lon, and city in locationManager
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
        }
    }
    
    // Get longitude/latitude and city string name
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationVal: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        GetWeather.shared.latitude = locationVal.latitude
        GetWeather.shared.longitude = locationVal.longitude
        
        getWeather()
        
        // Get Location to display in top right
        if let location = locations.last {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print(error)
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placemark = placemarks[0]
                        if let city = placemark.locality {
                            self.location = city
                            GetWeather.shared.city = city
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
