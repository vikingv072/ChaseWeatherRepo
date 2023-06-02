//
//  GlobalFuncs.swift
//  WeatherProject
//
//  Created by Kevin Varghese on 5/31/23.
//

import Foundation

func convertToFahrenheit(_ value: Double) -> String {
    let temp = ((value) * (9/5) + 32).rounded()
    return "\(temp) \u{00B0}F"
}

func showWindSpeed(_ value: Double) -> String {
    return "\(String(Int(value)))mph"
}

func showHumidity(_ value: Double) -> String {
    return "\(String(Int(value)))\u{0025}"
}
