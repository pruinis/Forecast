//
//  Helper.swift
//  Forecast
//
//  Created by Anton Morozov on 16.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit

class Helper {
    
    class func stringWithTemperatureIcon(double: Double?) -> String {
        return String(format: "%.0f", double ?? 0) + "°"
    }
    
    class func stringWithHumidityIcon(int: Int?) -> String {
        return String(int ?? 0) + "%"
    }
    
    class func stringWithWindSpeedIcon(float: Float?) -> String {
        return String(format: "%.0f", float ?? 0) + "m/sec"
    }
    
    class func separateHoursMinutesFromDateString(string: String?) -> (hours:Int?, minutes: Int?) {
        guard let string = string else { return (0, 0)}
        let dateFormatter = DateFormatter.fullDateWithTimeFormatter
        let date = dateFormatter.date(from: string)
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date ?? Date())
        let hour = comp.hour
        let minute = comp.minute
        return (hour, minute)
    }
    
    class func timeWithHoursAndMinutes(hours: Int?, minutes: Int?) -> String {
        let hoursStr = String(format: "%02d", hours ?? 0)
        let minutesStr = String(format: "%02d", minutes ?? 0)
        return hoursStr + ":" + minutesStr
    }
    
    class func timeWithHoursAndMinutesFromDateString(string: String?) -> String {
        let time = Helper.separateHoursMinutesFromDateString(string: string)
        return Helper.timeWithHoursAndMinutes(hours: time.hours, minutes: time.minutes)
    }
}
