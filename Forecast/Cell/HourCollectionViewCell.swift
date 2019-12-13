//
//  HourCollectionViewCell.swift
//  Forecast
//
//  Created by Anton Morozov on 15.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit
import OpenWeatherMapKit

class HourCollectionViewCell: UICollectionViewCell {
    
    static let hourCollectionViewCellId = "hourCollectionViewCellId"

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setWeather(weather: ForecastItem?) {
        
        // Time
        timeLabel.text = Helper.timeWithHoursAndMinutesFromDateString(string: weather?.dt_txt)
        
        // Image
        let weatherDesc = weather?.weather.first?.main
        imageView.image = WeatherIcon.weatherIconFromString(iconString: weatherDesc)
        
        // Temp
        let currentTemp = weather?.main.celsius.currentTemp
        tempLabel.text = Helper.stringWithTemperatureIcon(double: currentTemp)
    }
}
