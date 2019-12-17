//
//  MapVM.swift
//  Forecast
//
//  Created by Anton Morozov on 18.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit
import CoreLocation


protocol MapViewModalProtocol {        
    func selectCoordinate(coordinate: CLLocationCoordinate2D)
    var dismissHandler: (() -> ())? { get set }
}

class MapVM : MapViewModalProtocol {   
    
    weak var forecastVM: ForecastViewModalProtocol?
    var dismissHandler: (() -> ())?

    func selectCoordinate(coordinate: CLLocationCoordinate2D) {
        if CLLocationCoordinate2DIsValid(coordinate) {
            guard let forecastVM = forecastVM else {
                // Show error message
                return
            }
            forecastVM.reslove(coordinate: coordinate)
            dismissHandler?()
        }        
    }
}
