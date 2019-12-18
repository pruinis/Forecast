//
//  SearchVM.swift
//  Forecast
//
//  Created by Anton Morozov on 18.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation
import SwiftLocation
import CoreLocation

// MARK: - Protocol

protocol SearchViewModalProtocol {
    
    var searchResults: [Place]? { get }
    var geocodeComplition: ((_ places: [Place]?) -> ())? { get set }
    
    var dismissHandler: (() -> ())? { get set }
    func selectPlace(place: Place?)
    
    func finedPlaces(string: String)
    
}

// MARK: - Class

class SearchVM : SearchViewModalProtocol {
    
    weak var forecastVM: ForecastViewModalProtocol?

    var searchResults: [Place]?
    var dismissHandler: (() -> ())?
    var geocodeComplition: ((_ places: [Place]?) -> ())?
    private var geocodingRequest: GeocoderRequest?
    
    func finedPlaces(string: String) {
        geocodingRequest?.stop()
        geocodingRequest = LocationManager.shared.locateFromAddress(string) { [weak self] (result) in
            switch result {
              case .failure(let error):
                print("error \(error)")
              case .success(let places):
                DispatchQueue.main.async {
                    self?.searchResults = places
                    self?.geocodeComplition?(self?.searchResults)
                }
            }
        }    
    }
    
    func selectPlace(place: Place?) {
      
        guard let coordinate = place?.coordinates else {
            // Show error message
            return
        }
        
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
