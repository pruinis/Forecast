//
//  WeatherIcon.swift
//  Forecast
//
//  Created by Anton Morozov on 15.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit

class WeatherIcon {
    
    static let defaultImage = "default"
    
    enum WeatherType : String{
        case rain
        case snow
        case mist
        case smoke
        case haze
        case dust
        case fog
        case sand
        case ash
        case squall
        case tornado
        case clear
        case clouds
    }
    
    class func weatherIconFromString(iconString: String?) -> UIImage? {
        let lowercased = iconString?.lowercased()
        let type = WeatherType(rawValue: lowercased ?? String())
        var imageName: String

        switch type {
        case .rain:
            imageName = "rain"
        case .snow:
            imageName = "snow"
        case .clear:
            imageName = "clear-day"
        case .fog:
            imageName = "fog"
        case .clouds:
            imageName = "cloudy"
        default:
            imageName = defaultImage
        }
        return UIImage(named: imageName)
    }
}
