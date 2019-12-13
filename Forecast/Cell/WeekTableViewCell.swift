//
//  WeekTableViewCell.swift
//  Forecast
//
//  Created by Anton Morozov on 16.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit
import OpenWeatherMapKit

class WeekTableViewCell: UITableViewCell {
    
    static let weekTableViewCellId = "weekTableViewCellId"

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
                
        if selected {
            let color = Constants.lightBlueColor
            dayLabel.textColor = color
            tempLabel.textColor = color
            dropShadow(color: color, opacity: 0.25, offSet: CGSize(width: -1, height: 5), radius: 6, scale: true)
            blurView(style: .extraLight)
        }
        else {
            dayLabel.textColor = .black
            tempLabel.textColor = .black
            dropShadow(color: .clear, offSet: .zero)
            removeBlur()
        }        
    }
    
    func setForecast(forecast: [ForecastItem]?) {
        
        guard let dayForecast = forecast, !dayForecast.isEmpty else {
            let na = "N/A"
            dayLabel.text = na
            tempLabel.text = na
            weatherImageView.image = UIImage(named: WeatherIcon.defaultImage)
            return
        }
        
        guard let weather = dayForecast.first else {
            return
        }
        
        // Day
        dayLabel.text = weather.dt_txt?.dayOfTheWeekString()
        
        // Temp
        let maxTemp = dayForecast.compactMap{ $0.main.celsius.maxTemp }.max()
        let minTemp = dayForecast.compactMap{ $0.main.celsius.minTemp }.min()
        tempLabel.text = Helper.stringWithTemperatureIcon(double: maxTemp) + "/ " + Helper.stringWithTemperatureIcon(double: minTemp)

        // Image
        let weatherDesc = weather.weather.first?.main
        weatherImageView.image = WeatherIcon.weatherIconFromString(iconString: weatherDesc)
    }
}


