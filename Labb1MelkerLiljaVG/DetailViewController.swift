//
//  DetailViewController.swift
//  Labb1MelkerLiljaVG
//
//  Created by Melker Lilja on 2020-02-06.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController{
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var iconPic: UIImageView!
    
    var favCities: [String] = []
    var favCitiesTemp: [String] = []
    var favTemp: String = ""
    var cityName: String = ""
    var titleText = ""
    var iconText = ""
    let baseURL: String = "https://openweathermap.org/img/wn/"
    var iconURL: String = ""
    var isFavourite: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(titleText)"
        
        favCities = UserDefaults.standard.stringArray(forKey: "fav") ?? [String]()
        favCitiesTemp = UserDefaults.standard.stringArray(forKey: "favTemp") ?? [String]()
        
        isFavourite = UserDefaults.standard.bool(forKey: titleText)
        print("såhär många favoritstäder har jag \(favCities.count)")
        
        if isFavourite == true {
            let favouriteBtn = barButton(imageName: "starfilled", selector: #selector(favButtonPressed))
            navigationItem.rightBarButtonItems = [favouriteBtn]
        } else if isFavourite == false {
            let favouriteBtn = barButton(imageName: "star", selector: #selector(favButtonPressed))
            navigationItem.rightBarButtonItems = [favouriteBtn]
        } else {
            let favouriteBtn = barButton(imageName: "star", selector: #selector(favButtonPressed))
            navigationItem.rightBarButtonItems = [favouriteBtn]
        }

    
        iconPic.dropShadow()
        
        getWeatherInfo()
        // So the label doesn't disappear when it gets to long
        tipLabel.lineBreakMode = .byWordWrapping
        tipLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
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
                self.favTemp = city.main.temp.toString()
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
                self.tipLabel.text = self.recommendedClothes(description: city.weather[0].main, temp: city.main.temp)
            }
                case .failure(let error): print("Error \(error)")
            }
        }
    }
    
    @objc func favButtonPressed(sender: AnyObject){
        if UserDefaults.standard.bool(forKey: titleText) == true{
            
            UserDefaults.standard.removeObject(forKey: titleText)
            
            UserDefaults.standard.set(false, forKey: titleText)
            
            let favouriteBtn = barButton(imageName: "star", selector: #selector(favButtonPressed))
            
            navigationItem.rightBarButtonItems = [favouriteBtn]
            
            // Remove favourite city and temp from their arrays
            favCities = removeFavCity(city: titleText, favArr: favCities)
            favCitiesTemp = removeFavCityTemp(cityTemp: favTemp, favTempArr: favCitiesTemp)
            
            UserDefaults.standard.synchronize()
            
        } else if UserDefaults.standard.bool(forKey: titleText) == false{
            UserDefaults.standard.removeObject(forKey: titleText)
            UserDefaults.standard.set(true, forKey: titleText)
            let favouriteBtn = barButton(imageName: "starfilled", selector: #selector(favButtonPressed))
            navigationItem.rightBarButtonItems = [favouriteBtn]
            // Add favourite city temp to thei arrays
            favCities = addFavCity(city: titleText, favArr: favCities)
            favCitiesTemp = addFavCityTemp(cityTemp: favTemp, favTempArr: favCitiesTemp)
            UserDefaults.standard.synchronize()
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
            case "Rain":
                if temp < 10 {
                    tip = "Tip: Use warm clothes and waterproof jacket or umbrella, it's raining"
                } else {
                    tip = "Tip: Waterproof jacket or umbrella can be good today cuz it's raining"
                }
            case "Drizzle":
                if temp < 10 {
                    tip = "Tip: Use warm clothes and waterproof jacket or umbrella"
                } else {
                    tip = "Tip: Waterproof jacket or umbrella can be good today"
                }
            case "Snow":
                tip = "Tip: Use warm clothes, it's snowing"
            case "Thunderstorm":
                if temp < 10 {
                    tip = "Tip: Use warm clothes and waterproof jacket. Don't use umbrellas in thunderstorms"
                } else {
                    tip = "Tip: Waterproof clothes can be good, but not an umbrella when is lightning outside!"
                }
            case "Clear":
                if temp < 10 {
                    tip = "Tip: The sun is shining but it's cold, warm clothes are still needed"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: No clouds, just sunshine. Bring a jacket cuz it's not summer jet"
                } else {
                    tip = "Tip: It's fucking summer"
                }
            case "Clouds":
                if temp < 10 {
                    tip = "Tip: Cloudy and cold, dress warm"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: Cloudy outside so bring a jacket"
                } else {
                    tip = "Tip: Perfect summer day is here, mostly sunshine and some appreciated clouds once in a while"
                }
            case "Mist":
                if temp < 10 {
                    tip = "Tip: Warm clothes are recommended, pay attention when driving. It's misty outside"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: Mist is all over the place, bring a jacket"
                } else {
                    tip = "Tip: It's warm but misty outside. Pay attention if you are driving"
                }
            case "Smoke":
                if temp < 10 {
                    tip = "Tip: Smoke? Maybe a fire, I don't know. But it's freezing outside, use warm clothes"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: Smoke? There's a fire somewhere, be careful!"
                } else {
                    tip = "Tip: Smoke? It's hot and there's probably a fire somewhere, be careful!"
                }
            case "Haze":
                if temp < 10 {
                    tip = "Tip: Haze in the air and it's cold. Dress up"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: Hazey outside but the temperature is good, bring a jacket!"
                } else {
                    tip = "Tip: It's hot outside but it's hazey!"
                }
            case "Dust":
                if temp < 10 {
                    tip = "Tip: It's blowing dust and it's cold. Dress up, bring glasses for protection and a bandana for cover"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: Dust storm outside. Protect your eyes with glasses"
                } else {
                    tip = "Tip: Dust swirls in the heat. Protect eyes with glasses"
                }
            case "Fog":
                if temp < 10 {
                    tip = "Tip: Cold and foggy outside. Be careful if driving and have warm clothes"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: Fog is covering the air. Be careful if you're driving"
                } else {
                    tip = "Tip: It's warm and foggy"
                }
            case "Sand":
                tip = "Tip: Use warm clothes, it's snowing"
            case "Ash":
                if temp < 10 {
                    tip = "Tip: Vulcano are causing smoke, it's freezing and dangerous outside"
                } else if temp > 10 && temp < 20 {
                    tip = "Tip: Vulcano are causing smoke, don't go out. But the weather is nice otherwise"
                } else {
                    tip = "Tip: Vulcano are causing smoke, don't go out. Also summertime baby!"
                }
            case "Squall":
                tip = "Tip: Donno what the fuck squall is, probably not good"
            case "Tornado":
            tip = "Tip: A fucking tornado is going on. Hide in the basement or something"
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
    func addFavCity(city: String, favArr: [String]) -> [String] {
        var tempArr: [String] = []
        tempArr = favArr
        if tempArr.contains(city){
            return tempArr
        } else {
            tempArr.append(city)
            UserDefaults.standard.removeObject(forKey: "fav")
            UserDefaults.standard.set(tempArr, forKey: "fav")
            print("added city: \(city)")
            return tempArr
        }
    }
    
    func removeFavCity(city: String, favArr: [String]) -> [String] {
        var tempArr: [String] = []
        tempArr = favArr
        tempArr.removeAll { $0 == city }
        UserDefaults.standard.removeObject(forKey: "fav")
        UserDefaults.standard.set(tempArr, forKey: "fav")
        print("removed city temp: \(city)")
        return tempArr
    }
    
    func addFavCityTemp(cityTemp: String, favTempArr: [String]) -> [String] {
        var tempArr: [String] = []
        tempArr = favTempArr
        if tempArr.contains(cityTemp){
            return tempArr
        } else {
            tempArr.append(cityTemp)
            UserDefaults.standard.removeObject(forKey: "favTemp")
            UserDefaults.standard.set(tempArr, forKey: "favTemp")
            //UserDefaults.standard.synchronize()
            print("added city temp: \(cityTemp)")
            return tempArr
        }
    }
    
    func removeFavCityTemp(cityTemp: String, favTempArr: [String]) -> [String] {
        var tempArr: [String] = []
        tempArr = favTempArr
        tempArr.removeAll { $0 == cityTemp }
        UserDefaults.standard.removeObject(forKey: "favTemp")
        UserDefaults.standard.set(tempArr, forKey: "favTemp")
        print("removed city: \(cityTemp)")
        return favTempArr
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

extension UIViewController {
    func barButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    func barImageView(imageName: String) -> UIBarButtonItem {
        return UIBarButtonItem(customView: imageView(imageName: imageName))
    }
    
    private func imageView(imageName: String) -> UIImageView {
        let logo = UIImage(named: imageName)
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = logo
        logoImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return logoImageView
    }
}

