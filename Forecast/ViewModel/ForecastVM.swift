//
//  ForecastVM.swift
//  Forecast
//
//  Created by Anton Morozov on 14.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation
import SwiftLocation
import CoreLocation
import SwiftSpinner
import OpenWeatherMapKit

typealias ForecastData = (fiveDaysWeather: [[ForecastItem]]?, place: Place?)

// MARK: - Protocol

protocol ForecastViewModalProtocol : class {
    
    var selectedWeather: ForecastItem? { get }
    var selectedWeatherComplition: ((_ selectedWeather: ForecastItem?) -> ())? { get set }

    var selectedForecast: [ForecastItem]? { get }
    var selectedForecastComplition: ((_ selectedForecast: [ForecastItem]?) -> ())? { get set }

    var forecastData: ForecastData? { get }
    var resloveComplition: ((_ forecastData: ForecastData?) -> ())? { get set }

    func onViewDidLoad()
    func reslove(coordinate: CLLocationCoordinate2D)
    func selecteWeather(weather: ForecastItem?)
    func selectForecast(forecast: [ForecastItem]?)

}

// MARK: - Class

class ForecastVM : ForecastViewModalProtocol {
        
    var selectedWeather: ForecastItem?
    var selectedWeatherComplition: ((_ selectedWeather: ForecastItem?) -> ())?
    
    var selectedForecast: [ForecastItem]?
    var selectedForecastComplition: ((_ selectedForecast: [ForecastItem]?) -> ())?

    var forecastData: ForecastData?
    var resloveComplition: ((_ forecastData: ForecastData?) -> ())?
    
    private var lastCoordinate: CLLocationCoordinate2D?
    private var dispatchGroup: DispatchGroup?

    init(group: DispatchGroup) {
        dispatchGroup = group
    }
    
    func onViewDidLoad() {
        chekLocationAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func reslove(coordinate: CLLocationCoordinate2D) {
        
        SwiftSpinner.show(Constants.loadingString)
        
        selectedForecast = nil
        selectedWeather = nil
        lastCoordinate = coordinate
        forecastData = ForecastData(nil, nil)
        getFiveDaysWeather(coordinate: coordinate)
        geocodPlace(coordinate: coordinate)
                
        dispatchGroup?.notify(queue: .main) {
            self.selectedForecast = self.forecastData?.fiveDaysWeather?.first
            self.selectedWeather = self.selectedForecast?.first
            self.resloveComplition?(self.forecastData)
            SwiftSpinner.hide()
        }
    }
    
    func selectForecast(forecast: [ForecastItem]?) {
        DispatchQueue.main.async {
            self.selectedForecast = forecast
            self.selectedForecastComplition?(self.selectedForecast)
        }
    }
    
    func selecteWeather(weather: ForecastItem?) {
        DispatchQueue.main.async {
            self.selectedWeather = weather
            self.selectedWeatherComplition?(self.selectedWeather)
        }
    }
}

extension ForecastVM {
    
    // MARK: - LocationManager
    
    fileprivate func chekLocationAuthorization() {
        SwiftSpinner.show(Constants.loadingString)
        switch LocationManager.state {
        case .available: getCoordinate()
        case .undetermined: requireUserAuthorization()
        default: showAllowLocationPromt()
        }
        
        let state = LocationManager.state
        LocationManager.shared.onAuthorizationChange.add({ [weak self] newState in
            // Authorization status changed
            switch newState {
            case .available:
                if state != .available {
                    self?.getCoordinate()
                }
            case .undetermined: break // do nothing
            default: self?.showAllowLocationPromt()
            }
        })
    }
    
    fileprivate func requireUserAuthorization() {
        LocationManager.shared.requireUserAuthorization(.whenInUse)
    }
    
    fileprivate func getCoordinate() {
        LocationManager.shared.locateFromGPS(.oneShot, accuracy: .block) { [weak self] (result) in
            switch result {
            case .success(let location):
                self?.reslove(coordinate: location.coordinate)
            case .failure(let error):
                // Unfortunately we can't resolve coordinates
                // Please provide defoult UI for same cases
                print("error \(error)")
            }
        }
    }

    fileprivate func geocodPlace(coordinate: CLLocationCoordinate2D) {
        dispatchGroup?.enter()
        let options = GeocoderRequest.Options()
        LocationManager.shared.locateFromCoordinates(coordinate, timeout: nil, service: .apple(options)) { [weak self] (result) in
            
            defer { self?.dispatchGroup?.leave() }

            switch result {
              case .failure(let error):
                print("error \(error)")
              case .success(let places):
                self?.forecastData?.place = places.first
            }
        }
    }
}

extension ForecastVM {
    
    // MARK: - OpenWeatherMapKit
    
    fileprivate func getFiveDaysWeather(coordinate: CLLocationCoordinate2D) {
        
        dispatchGroup?.enter()
        let coordinateTuple = (latitude: coordinate.latitude, longitude: coordinate.longitude)
        OpenWeatherMapKit.instance.weatherForecastForFiveDays(forCoordiante: coordinateTuple) { [weak self] (result, error) in
                        
            defer { self?.dispatchGroup?.leave() }

            if let error = error {
                print("error \(error)")
                return
            }
            
            guard let list = result?.list else {
                return
            }
            
            let daysArray = list.compactMap ({ $0.dt_txt })                     // get full date string
                .reduce(into: []) { $0.append($1.fullDateStringWithoutTime()) } // trim time
                .reduce(into: []) { !$0.contains($1) ? $0.append($1) : () }     // filter unique values
            
            var total = [[ForecastItem]]()
            daysArray.forEach { (dayStr) in
                let dayItems = list.filter ({ ($0.dt_txt?.contains(dayStr) ?? false) })
                total.append(dayItems)
            }
                        
            self?.forecastData?.fiveDaysWeather = total
        }
    }
}

extension ForecastVM {
    
    // MARK: - Messages
    
    fileprivate func showMessage(string: String) {
        SwiftSpinner.show(string).addTapHandler({
            SwiftSpinner.hide()
        })
    }
    
    fileprivate func showAllowLocationPromt() {
        SwiftSpinner.show(Constants.allowLocationString)
    }
    
    @objc
    func applicationDidBecomeActive() {
        if LocationManager.state == .denied {
            showAllowLocationPromt()
        }
        else if SwiftSpinner.shared.animating &&
            SwiftSpinner.shared.title == Constants.allowLocationString {
            SwiftSpinner.hide()
        }
    }
}
