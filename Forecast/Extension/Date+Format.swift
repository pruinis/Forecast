//
//  Date+Format.swift
//  Forecast
//
//  Created by Anton Morozov on 16.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation

extension Date {
    
    func dayWithDateString() -> String {
        let formatter = DateFormatter.dayOfMonthFormatter
        return formatter.string(from: self)
    }
}
