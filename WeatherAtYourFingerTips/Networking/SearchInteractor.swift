//
//  SearchInteractor.swift
//  WeatherAtYourFingerTips
//
//  Created by Vaibhav Singh on 07/07/20.
//  Copyright © 2020 Vaibhav Singh. All rights reserved.
//

import Foundation

class SearchInteractor {
    
    let apiKey = "8f87e75d23a628e49e586d96291c2985"
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    func buildUrl(city: String) -> URL? {
        let queryItems = [URLQueryItem(name: "q", value: city),
                          URLQueryItem(name: "appid", value: apiKey)]
        var urlComps = URLComponents(string: baseUrl)
        urlComps?.queryItems = queryItems
        return urlComps?.url
    }
    
    func searchData(city: String ,completion: @escaping (Error?, WeatherDetails?) -> ()) {
        guard let url = buildUrl(city: city) else {
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: {[weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            if let clientError = error {
                completion(clientError, nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = self.getServerError()
                completion(error, nil)
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(WeatherDetails.self, from: data)
                    completion(nil, result)
                } catch {
                    completion(error, nil)
                    return
                }
            }
            
            }).resume()
        
    }
    
    func getServerError() -> Error {
        // parse the data to get server error here
        return NSError()
    }
}
