//
//  SwinjectStoryboard+Setup.swift
//  Forecast
//
//  Created by Anton Morozov on 15.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit

import SwinjectStoryboard

extension SwinjectStoryboard {
    
    class func setup() {
        defaultContainer.storyboardInitCompleted(ForecastVC.self) { r, c in
            c.viewModel = r.resolve(ForecastViewModalProtocol.self)
        }
        
        defaultContainer.storyboardInitCompleted(MapVC.self) { r, c in
            c.viewModel = r.resolve(MapViewModalProtocol.self)
        }
        
        defaultContainer.register(ForecastViewModalProtocol.self) { _ in ForecastVM(group: DispatchGroup()) }
        defaultContainer.register(MapViewModalProtocol.self) { _ in MapVM() }
    }
}
