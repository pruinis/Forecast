//
//  ForecastVC.swift
//  Forecast
//
//  Created by Anton Morozov on 14.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit

class ForecastVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dayView: DayView!
    @IBOutlet weak var hoursCollectionView: UICollectionView!
    @IBOutlet weak var weekTableView: UITableView!
    
    var viewModel: ForecastViewModalProtocol?
    
    let showMapSegue = "showMapSegue"
    let showSearchSegue = "showSearchSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Constants.darkBlueColor
        
        updateCollectionView()
        updateTableView()
        
        // MARK: - View Model actions

        viewModel?.onViewDidLoad()
        viewModel?.resloveComplition = { [weak self] forecastData in            
            self?.dayView.setWeather(place: forecastData?.place, weather: self?.viewModel?.selectedWeather)
            self?.hoursCollectionView.reloadData()
            self?.weekTableView.reloadData()
        }
        
        viewModel?.selectedForecastComplition = { [weak self] forecast in
            self?.dayView.setWeather(place: self?.viewModel?.forecastData?.place, weather: forecast?.first)
            self?.hoursCollectionView.reloadData()
        }
        
        viewModel?.selectedWeatherComplition = { [weak self] weather in
            self?.dayView.setWeather(place: self?.viewModel?.forecastData?.place, weather: weather)
        }
        
        // MARK: - DayView actions

        dayView.mapButtonPressedHandler = {
            self.performSegue(withIdentifier: self.showMapSegue, sender: self)
        }
        
        dayView.cityButtonPressedHandler = {
            self.performSegue(withIdentifier: self.showSearchSegue, sender: self)
        }
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if  segue.identifier == showMapSegue,
            let destination = segue.destination as? MapVC {
            guard let mapViewModel = destination.viewModel as? MapVM else { return }
            mapViewModel.forecastVM = self.viewModel        
        }
        else if  segue.identifier == showSearchSegue,
            let destination = segue.destination as? SearchTableVC {
            guard let mapViewModel = destination.viewModel as? SearchVM else { return }
            mapViewModel.forecastVM = self.viewModel
        }
    }
}

extension ForecastVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func updateCollectionView() {
        hoursCollectionView.backgroundColor = Constants.lightBlueColor
        hoursCollectionView.register(UINib.init(nibName: "HourCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HourCollectionViewCell.hourCollectionViewCellId)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 75, height: hoursCollectionView.frame.size.height)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        hoursCollectionView.collectionViewLayout = layout
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.selectedForecast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourCollectionViewCell.hourCollectionViewCellId, for: indexPath) as! HourCollectionViewCell
        
        let weather = viewModel?.selectedForecast?[indexPath.row]
        cell.setWeather(weather: weather)
        return cell        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weather = viewModel?.selectedForecast?[indexPath.row]
        viewModel?.selecteWeather(weather: weather)
    }
}

extension ForecastVC : UITableViewDelegate, UITableViewDataSource {
    
    func updateTableView() {
        weekTableView.backgroundColor = .white        
        let cell = UINib.init(nibName: "WeekTableViewCell", bundle: nil)
        weekTableView.register(cell, forCellReuseIdentifier: WeekTableViewCell.weekTableViewCellId)
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.forecastData?.fiveDaysWeather?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeekTableViewCell.weekTableViewCellId, for: indexPath) as! WeekTableViewCell

        let forecast = viewModel?.forecastData?.fiveDaysWeather?[indexPath.row]
        cell.setForecast(forecast: forecast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let forecast = viewModel?.forecastData?.fiveDaysWeather?[indexPath.row]
        viewModel?.selectForecast(forecast: forecast)
    }
}
