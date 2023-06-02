//
//  WeatherModel.swift
//  WeatherProject
//
//  Created by Kevin Varghese on 5/31/23.
//

import Foundation

struct WeatherModel: Decodable, Equatable {
    let name: String
    let coord: Coordinate?
    let main: Main?
    let wind: Wind?
    let weather: [Weather]?
    let visibility: Double
    
    static func == (lhs: WeatherModel, rhs: WeatherModel) -> Bool {
        return lhs.name == rhs.name
    }
}

struct Coordinate: Decodable {
    let lon, lat : Double
}

struct Main: Decodable {
    let temp, feels_like, humidity: Double
}

struct Wind: Decodable {
    let speed: Double
}

struct Weather: Decodable {
    let main, description, icon: String
}
