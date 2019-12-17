//
//  MapVC.swift
//  Forecast
//
//  Created by Anton Morozov on 17.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var gestureRecognizer: UILongPressGestureRecognizer!
    
    var viewModel: MapViewModalProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.userTrackingMode = .follow
        
        viewModel?.dismissHandler = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - UILongPressGestureRecognizer
    
    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {        
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        viewModel?.selectCoordinate(coordinate: locationCoordinate)
    }
}
