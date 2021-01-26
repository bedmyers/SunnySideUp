//
//  ForecastTableViewController.swift
//  Sunny Side Up
//
//  Created by Blair Myers on 1/24/21.
//  Copyright © 2021 Blair Myers. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    @IBOutlet var timeLabels: [UILabel]!
    @IBOutlet var temperatureLabels: [UILabel]!
    @IBOutlet var weatherIcons: [UIImageView]!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ForecastTableViewController: UITableViewController {
    
    // We know the specific times the forecast covers, and next 5 days only, so create a few arrays for data
    var nextFiveDates = [String]()
    var timeArray = ["3am", "6am", "9am", "12pm", "3pm", "6pm", "9pm", "12am"]
    
    // Values to keep track of which tableView section should be expanded
    var expanded = Array(repeating: false, count: 5)
    var currentSection = -1

    var forecastData: ForecastResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Already know what the dates will be without the data, so update now
        getNextFiveDates()
        
        // Fill in forecastData with API call
        getForecast()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Add extra section to imrove UI and get rid of tableView lines
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If user touched section to expand cell, then show the rows
        if section != 5 {
            if expanded[section] == true {
                return 2
            }
        }
        
        // Section will have zero rows if it hasn't been tapped
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 5 {
            // Add filler spacing to remove tableView lines
            return 200
        }

        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        
        if section != 5 {
            
            // Section header will be a button. If the user pressed on the section, then the rows will expand
            sectionButton.setTitle(nextFiveDates[section],
                                   for: .normal)
            
            sectionButton.setTitleColor(UIColor.label, for: .normal)
            
            // Make the sections different colors so they don't blend in
            if section % 2 == 0 {
                sectionButton.backgroundColor = UIColor.gray
            } else {
                sectionButton.backgroundColor = UIColor.lightGray
            }
            
            // Hacky way to see what section has been selected
            sectionButton.tag = section
            
            // Create a target for the button
            sectionButton.addTarget(self, action: #selector(expandTableViewSection), for: .touchUpInside)
        }
        
        return sectionButton
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell") as! ForecastCell
        
        // We know there are 40 entries in the list Array, so use row/section to get proper starting index
        var index = (indexPath.section * 8) + (indexPath.row * 4)
        
        
        // Set temperature labels
        for label in cell.temperatureLabels {
            if let temperature = forecastData?.list?[index].main?.temp?.rounded() {
                let tempDisplay = "\(Int(temperature.rounded()))"
                label.text = tempDisplay + "°"
            }
            index += 1
        }
        
        
        // Set weather icons
        index -= 4
        for weatherIcon in cell.weatherIcons {
            if let icon = forecastData?.list?[index].weather?.first?.icon {
                
                // Get icon from url with icon data from API call
                let url = URL(string: "http://openweathermap.org/img/w/" + icon + ".png")
                 
                // Go back to main thread to update the UI
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                     
                    DispatchQueue.main.async {
                        weatherIcon.image = UIImage(data: data!)
                    }
                }
            }
            
            index += 1
        }
        
        
        // Set time labels. No need to get index, all timeArray elements are used
        index = indexPath.row * 4
        for label in cell.timeLabels {
            label.text = timeArray[index]
            index += 1
        }
        
        return cell
    }
    
    @objc func expandTableViewSection(sender: UIButton!) {
        
        // Get the tag from the button to identify section. If it is already expanded, close it up, and vice versa
        if expanded[sender.tag] == false {
            expanded[sender.tag] = true
        } else {
            expanded[sender.tag] = false
        }
        tableView.reloadData()
    }
    
    
    func getForecast() {
        
        // Make sure city is initialized
        if let loco = GetWeather.shared.city {
            
            GetWeather.shared.getForecast(city: loco) {
                result in
                self.forecastData = result
                
                // Need to reload data because tableView has probably already loaded with default vals
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // Get the next 5 dates based on the current date
    func getNextFiveDates() {
        
        // We know forecast only covers next 5 days, so we can identify them here instead of retrieving from the API
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, M/d"
        
        // Store formatted strings in array
        for i in 1...5 {
            let date = Calendar.current.date(byAdding: .day, value: i, to: Date())!
            let formattedDate = formatter.string(from: date)
            nextFiveDates.append(formattedDate)
        }
    }
    
    
}
