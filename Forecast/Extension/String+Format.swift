//
//  String+Format.swift
//  Forecast
//
//  Created by Anton Morozov on 16.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation

extension String {
    
    func fullDateStringWithoutTime() -> String {
        if self.isEmpty { return String() }
        let formatterWithTime = DateFormatter.fullDateWithTimeFormatter
        let date = formatterWithTime.date(from: self) ?? Date()
        let formatterWithoutTime = DateFormatter.fullDateWithoutTimeFormatter
        return formatterWithoutTime.string(from: date)
    }
    
    func dayOfTheWeekString() -> String? {
        let formatterWithTime = DateFormatter.fullDateWithTimeFormatter
        let date = formatterWithTime.date(from: self) ?? Date()
        let formatterDay = DateFormatter.dayOfTheWeekFormatter
        return formatterDay.string(from: date)
    }
}
