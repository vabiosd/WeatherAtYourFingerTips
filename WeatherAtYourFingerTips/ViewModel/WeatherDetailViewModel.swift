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
    var temperatureString = ""
    var weatherDescriptionString = ""
    var minMaxString = ""
    var windSpeed = ""
    var humidity = ""
    
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
                if let temp = weatherDetails.temperatureDetails?.temp, let feelsLikeTemp = weatherDetails.temperatureDetails?.feels_like {
                    self.temperatureString = "\(Int(temp - 273.15))°C ( feels like \(Int(feelsLikeTemp - 273.15))°C)"
                }
                
                self.weatherDescriptionString = weatherDetails.weatherDescription?.first?.description ?? ""
                if let min = weatherDetails.temperatureDetails?.temp_min, let max = weatherDetails.temperatureDetails?.temp_max {
                    self.minMaxString = "Minimum: \(Int(min - 273.15))°C \nMaximum: \(Int(max - 273.15))°C"
                }
                
                if let speed = weatherDetails.wind?.speed {
                    self.windSpeed = "Humidity: \(Int(speed)) meter/sec"
                }
                
                if let humidity = weatherDetails.temperatureDetails?.humidity {
                    self.humidity = "Wind Speed: \(Int(humidity))%"
                }
               
                self.reloadData?()
            }
        }
    }
    
}
