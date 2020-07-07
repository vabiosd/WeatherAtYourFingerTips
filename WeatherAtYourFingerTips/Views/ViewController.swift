//
//  ViewController.swift
//  WeatherAtYourFingerTips
//
//  Created by Vaibhav Singh on 07/07/20.
//  Copyright © 2020 Vaibhav Singh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupDoubleTapGesture()
    }
    
    func setupDoubleTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getLocationAndWeather(_:)))
        tapGesture.numberOfTapsRequired = 2
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
    }


}

extension ViewController: UIGestureRecognizerDelegate {
    @objc func getLocationAndWeather(_ gesture: UITapGestureRecognizer  ) {
        let tapLocation = gesture.location(in: mapView)
        let coordinates = mapView.convert(tapLocation, toCoordinateFrom: mapView)
        let detailViewController = WeatherDetailViewController()
        detailViewController.setupViewModel(location: coordinates)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

