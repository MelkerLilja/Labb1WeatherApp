//
//  WeatherInfo.swift
//  Labb1MelkerLiljaVG
//
//  Created by Melker Lilja on 2020-02-13.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import Foundation

struct WeatherInfo: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Wind: Decodable {
    let speed: Double
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let main: String
    let icon: String
}

extension Double {
    func toString() -> String {
        return String(format: "%.1f", self)
    }
}
