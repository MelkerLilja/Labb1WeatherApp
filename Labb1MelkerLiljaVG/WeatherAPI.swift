//
//  WeatherAPI.swift
//  Labb1MelkerLiljaVG
//
//  Created by Melker Lilja on 2020-02-13.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import Foundation

struct WeatherAPI {
    let baseURL: String = "https://api.openweathermap.org/data/2.5/weather?q="
    let apiKey: String = "&appid=f04fde54a1d1534ffae772a0029b6b24"
    let metric: String = "&units=metric"
    
    func getCityStats(searchText: String, completion: @escaping(Result<WeatherInfo,Error>) -> Void)  {
        // url
        let urlString = baseURL + searchText + apiKey + metric
        print(urlString)
        guard let url: URL = URL(string: urlString) else { return }
        // Request
        print("Creating request..")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let unwrappedError = error {
                print("Nått gick fel. Error: \(unwrappedError)")
                completion(.failure(unwrappedError))
                return
            }
            if let unwrappedData = data {
                do {
                    let decoder = JSONDecoder()
                    let city: WeatherInfo = try decoder.decode(WeatherInfo.self, from: unwrappedData)
                    print("City name: \(city.name)")
                    print("City temp: \(city.main.temp)")
                    print(city.weather[0].description)
                    completion(.success(city))
                } catch {
                    print("Couldnt parse JSON..")
                }
            }
        }
        // Starta task
        task.resume()
        print("Task started")
    }
}


