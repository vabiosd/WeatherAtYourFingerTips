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
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupDoubleTapGesture()
        setupLocationManager()
    }
    
    func setupDoubleTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getLocationAndWeather(_:)))
        tapGesture.numberOfTapsRequired = 2
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
    }

    func setupLocationManager() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Check for Location Services

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
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

extension ViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }

        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }
}

