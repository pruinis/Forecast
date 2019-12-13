//
//  DateFormatter+Format.swift
//  Forecast
//
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let fullDateWithTimeFormatter: DateFormatter = {
        return prepareFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")
    }()
    
    static let fullDateWithoutTimeFormatter: DateFormatter = {
        return prepareFormatter(dateFormat: "yyyy-MM-dd")
    }()
    
    static let dayOfMonthFormatter: DateFormatter = {
        return prepareFormatter(dateFormat: "E, d")
    }()
    
    static let dayOfTheWeekFormatter: DateFormatter = {
        return prepareFormatter(dateFormat: "E")
    }()
        
    private class func prepareFormatter(dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}

