//
//  DayView.swift
//  Forecast
//
//  Created by Anton Morozov on 14.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit
import SwiftLocation
import OpenWeatherMapKit

class DayView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!    
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var rainManLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("DayView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = Constants.darkBlueColor
    }
    
    func setWeather(place: Place?, weather: ForecastItem?) {
                
        // City
        cityLabel.text = place?.city
        
        // Date
        let date = Date(timeIntervalSince1970: weather?.dt ?? 0)            
        dayLabel.text = date.dayWithDateString()
        
        // Temp
        let maxTemp = weather?.main.celsius.maxTemp
        let minTemp = weather?.main.celsius.minTemp
        rainManLabel.text = Helper.stringWithTemperatureIcon(double: maxTemp) + "/ " + Helper.stringWithTemperatureIcon(double: minTemp)
        
        // Humidity
        humidityLabel.text = Helper.stringWithHumidityIcon(int: weather?.main.humidity)
        
        // Wind
        windLabel.text = Helper.stringWithWindSpeedIcon(float: weather?.wind.speed)
        
        // Image
        let weatherDesc = weather?.weather.first?.main
        weatherImageView.image = WeatherIcon.weatherIconFromString(iconString: weatherDesc)
    }
}
