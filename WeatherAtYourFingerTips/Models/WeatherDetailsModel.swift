//
//  WeatherDetailsModel.swift
//  WeatherAtYourFingerTips
//
//  Created by Vaibhav Singh on 07/07/20.
//  Copyright © 2020 Vaibhav Singh. All rights reserved.
//

import Foundation

struct WeatherDetails: Decodable {
    var weatherDescription: [Weather]?
    var temperatureDetails: Temperature?
    var wind: Wind?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "weather", temperatureDetails = "main", wind, name
    }
    
    enum DescriptionCodingKeys: String, CodingKey {
        case weatherType = "main", description, icon
    }
    
    enum TemperatureCodingkeys: String, CodingKey {
        case temp, feels_like, temp_min, temp_max, humidity
    }
    
    enum WindCodingKeys: String, CodingKey {
        case speed, deg
    }
}

struct Weather: Decodable {
    var weatherType: String?
    var description: String?
    var icon: String?
}

struct Temperature: Decodable {
    var temp: Double?
    var feels_like: Double?
    var temp_min: Double?
    var temp_max: Double?
    var humidity: Double?
}

struct Wind: Decodable {
    var speed: Double?
    var deg: Double?
}
