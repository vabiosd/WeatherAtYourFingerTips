//
//  WeatherDetailViewModel.swift
//  WeatherAtYourFingerTips
//
//  Created by Vaibhav Singh on 07/07/20.
//  Copyright © 2020 Vaibhav Singh. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class WeatherDetailViewModel {
    
    var reloadData: (() -> ())?
    var showError: ((String) -> ())?
    let interactor = SearchInteractor()
    
    var cityName = ""
    var iconUrl = ""
    
    func getWeatherData(location: CLLocationCoordinate2D) {
        // show loading
        self.interactor.searchData(latitude: location.latitude.magnitude, longitude: location.longitude.magnitude) {[weak self] (error, weatherDetails) in
            guard let self = self else {
                return
            }
            if let error = error {
                self.showError?(error.localizedDescription)
            } else if let weatherDetails = weatherDetails {
                self.cityName = weatherDetails.name ?? ""
                self.iconUrl = "http://openweathermap.org/img/wn/\(weatherDetails.weatherDescription?.first?.icon ?? "")@2x.png"
                self.reloadData?()
            }
        }
    }
    
}
