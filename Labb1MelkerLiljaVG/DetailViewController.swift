//
//  DetailViewController.swift
//  Labb1MelkerLiljaVG
//
//  Created by Melker Lilja on 2020-02-06.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var starButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var iconPic: UIImageView!
    
    var cityName: String = ""
    var titleText = ""
    var iconText = ""
    let baseURL: String = "https://openweathermap.org/img/wn/"
    var iconURL: String = ""
    var celsiusTemp: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconPic.dropShadow()
        
        self.title = "\(titleText)"
        
        getWeatherInfo()
        
        // So the label doesn't disappear when it gets to long
        tipLabel.lineBreakMode = .byWordWrapping
        tipLabel.numberOfLines = 0
        
    }

    func getWeatherInfo(){
        print("Trying to get weather info")
        let weatherApi = WeatherAPI()
        let searchedCity = titleText.removeWhitespace()
        weatherApi.getCityStats(searchText: searchedCity){ (result) in
            switch result {
               case .success(let city):
                    print("City name: " + (city.name))
                    //print("City temp: " + (city.main.temp.toString()))
            DispatchQueue.main.async {
                // Uppdatera UI
                self.cityName = city.name
                self.descriptionLabel.text = city.weather[0].description
                self.tempLabel.text = city.main.temp.toString() + "°C"
                self.windLabel.text = "\(city.wind.speed) m/s"
                self.iconText = "\(city.weather[0].icon)@2x.png"
                if city.weather[0].icon.contains("d"){
                    self.setBackground(dayOrNight: true)
                } else {
                    self.setBackground(dayOrNight: false)
                }
                
                self.iconURL = self.baseURL + self.iconText
                print(self.iconURL)
                self.setImage(url: self.iconURL)
                self.tipLabel.text = self.recommendedClothes(description: city.weather[0].description, temp: city.main.temp)
            }
                case .failure(let error): print("Error \(error)")
            }
        }
    }
    
    func setImage(url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.iconPic.image = image
            }
        }
    }
    
    func recommendedClothes(description: String, temp: Double) -> String{
        var tip: String = ""
        switch description {
            case "shower rain":
                if temp < 10 {
                    tip = "Tip: Use warm clothes and waterproof jacket or umbrella"
                } else {
                    tip = "Tip: Waterproof jacket or umbrella can be good today"
                }
            case "rain":
                if temp < 10 {
                    tip = "Tip: Use warm clothes and waterproof jacket or umbrella"
                } else {
                    tip = "Tip: Waterproof jacket or umbrella can be good today"
                }
            case "snow":
                tip = "Tip: Use warm clothes. It's cold outside"
            case "thunderstorm":
                if temp < 10 {
                    tip = "Tip: Use warm clothes and waterproof jacket. Don't use umbrellas in thunderstorms"
                } else {
                    tip = "Tip: Waterproof clothes can be good, but not an umbrella when is lightning outside!"
                }
            case "clear sky":
                if temp < 10 {
                    tip = "Tip: The sun is shining but it's cold, warm clothes are still needed"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: It's getting warm, bring a jacket"
                } else {
                    tip = "Tip: It's fucking summer"
                }
            case "few clouds":
                if temp < 10 {
                    tip = "Tip: Use warm clothes because it's cold"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: Dress like it's autumn or early spring"
                } else {
                    tip = "Tip: Perfect summer day is here, mostly sunshine and some appreciated clouds once in a while"
                }
            case "scattered clouds":
                if temp < 10 {
                    tip = "Tip: Warm clothes are recommended"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: Typical autumn/spring day"
                } else {
                    tip = "Tip: It's warm with a chance of rain. Bring umbrella or take the chance"
                }
            case "broken clouds":
                if temp < 10 {
                    tip = "Tip: Dude it's cold, dress accordingly"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: Autumn or spring is here. Big chance it might rain"
                } else {
                    tip = "Tip: It's warm with a big chance of rain. Bring umbrella or take the chance"
                }
            case "mist":
                if temp < 10 {
                    tip = "Tip: You can't see shit and it's cold. Dress up"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: Still can't see shit but it's getting warmer"
                } else {
                    tip = "Tip: Fog but it's warm"
                }
        default:
            print("Tip: Look outside and ")
        }
        
        return tip
    }
    
    func setBackground(dayOrNight: Bool) {
        if dayOrNight == true {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            let colorBottom = UIColor(red: 201.0/255.0, green: 175.0/255.0, blue: 4.0/255.0, alpha: 1.0).cgColor
            let colorTop = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
            gradientLayer.colors = [colorTop,colorBottom]
            gradientLayer.shouldRasterize = true
            // Apply the gradient to the backgroundGradientView.
            backgroundView.layer.addSublayer(gradientLayer)
        } else {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            let colorBottom = UIColor(red: 149.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1.0).cgColor
            let colorTop = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
            gradientLayer.colors = [colorTop,colorBottom]
            gradientLayer.shouldRasterize = true
            // Apply the gradient to the backgroundGradientView.
            backgroundView.layer.addSublayer(gradientLayer)
        }
    }
        
    @IBAction func starButtonPressed(_ sender: Any) {
     /*
            starButton.setImage(UIImage(named: "starfilled.png"), for: .normal)
        }
        starButton.setImage(UIImage(named: "starfilled.png"), for: .normal)
 */
    }
}
    


extension String {
  func replace(string:String, replacement:String) -> String {
      return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
  }

  func removeWhitespace() -> String {
      return self.replace(string: " ", replacement: "%20")
  }
}

extension UIImageView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

