//
//  Models.swift
//  JPMCWeatherApp
//
//  Created by Diego Eduardo on 9/26/23.
//

import Foundation

struct City: Codable {
    var name: String
    var main: Main
    var sys: SunData
    var weather: [Weather]
    var clouds: Clouds
    var wind: Wind
    var timezone: Double
}

struct Wind: Codable {
    var speed: Double
    var deg: Double //Direction
}

struct Clouds: Codable {
    var all: Double
}
struct SunData: Codable {
    var sunrise: Double
    var sunset: Double
}

struct Main: Codable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Double
    var humidity: Double
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Alert: Codable {
    var sender_name: String
    var event: String
    var start: Double
    var end: Double
    var description: String
}
