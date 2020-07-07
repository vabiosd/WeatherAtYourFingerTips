//
//  Extensions.swift
//  WeatherAtYourFingerTips
//
//  Created by Vaibhav Singh on 07/07/20.
//  Copyright © 2020 Vaibhav Singh. All rights reserved.
//

import Foundation

import Foundation
import UIKit

let imageCache: NSCache<AnyObject, AnyObject> = NSCache()

class CustomImageView: UIImageView {
    var imageUrlString: String?
    func loadImageAtUrl(urlString: String, completion: (() -> ())? = nil) {
        self.contentMode = .scaleAspectFit
        self.imageUrlString = urlString
        self.layer.masksToBounds = true
        guard let url = URL(string: urlString) else {
            return
        }
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = imageFromCache
            completion?()
            return
        }
        URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    if urlString == self?.imageUrlString {
                        self?.image = image
                        completion?()
                    }
                }
            }
        }.resume()
    }
}
