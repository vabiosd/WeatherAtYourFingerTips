//
//  WeatherDetailViewController.swift
//  WeatherAtYourFingerTips
//
//  Created by Vaibhav Singh on 07/07/20.
//  Copyright © 2020 Vaibhav Singh. All rights reserved.
//

import UIKit
import MapKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: CustomImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minMaxTemperature: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    let loadingIndicator: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    var weatherDetailViewModel = WeatherDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoadingIndicator()
    }
    
    func setupViewModel(city: String) {
        weatherDetailViewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.removeLoadingView()
                self.cityName.text = self.weatherDetailViewModel.cityName
                self.iconImageView.loadImageAtUrl(urlString: self.weatherDetailViewModel.iconUrl) {
                    self.iconImageView.isHidden = false
                }
                self.temperatureLabel.text = self.weatherDetailViewModel.temperatureString
                self.descriptionLabel.text = self.weatherDetailViewModel.weatherDescriptionString
                self.minMaxTemperature.text = self.weatherDetailViewModel.minMaxString
                self.humidityLabel.text = self.weatherDetailViewModel.humidity
                self.windLabel.text = self.weatherDetailViewModel.windSpeed
            }
        }
        
        weatherDetailViewModel.showError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.removeLoadingView()
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
        weatherDetailViewModel.getWeatherData(city: city)
    }
    
    func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func showLoadingView(){
        self.view.backgroundColor = .lightGray
        loadingIndicator.startAnimating()
    }
    
    func removeLoadingView() {
        self.view.backgroundColor = .white
        loadingIndicator.stopAnimating()
    }
}
