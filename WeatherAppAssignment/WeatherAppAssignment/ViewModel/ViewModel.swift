//
//  ViewModel.swift
//  WeatherProject
//
//  Created by Kevin Varghese on 5/31/23.
//

import Foundation

final class ViewModel: ObservableObject, LocationManagerProtocol {
    
    private let userDef = UserDefaults.standard
    @Published var weatherDisplay: WeatherModel?
    
    private let networkManager: NetworkRepresentable
    private var locationManager: LocationManagerService
    
    init(networkManager: NetworkRepresentable, locationManager: LocationManagerService) {
        self.networkManager = networkManager
        self.locationManager = locationManager
    
        self.locationManager.delegate = self
        guard let name = userDef.string(forKey: "city") else { return }
        Task {
            await weatherForCity(city: name)
        }
    }
    
    // levaraging the network Manager for weather using coordinates
    func weatherForCoordinates(lat: Double, lon: Double) async {
        do {
            var urlString = APIEndpoints.currentWeatherURL
            urlString += "lat=\(lat)&"
            urlString += "lon=\(lon)&"
            urlString += "appid=\(APIEndpoints.apiKey)&"
            urlString += "units=metric"
            let weather = try await networkManager.fetchWeather(urlStr: urlString)
            userDef.set(weather.name, forKey: "city")
            DispatchQueue.main.async { [weak self] in
                self?.weatherDisplay = weather
            }
        } catch let error {
            print("Could not fetch weather using coordinates due to: \(error.localizedDescription)")
        }
    }
    
    // levaraging the network Manager for weather using city name
    func weatherForCity(city: String) async {
        let refinedCityString = city.replacingOccurrences(of: " ", with: "%20")
        do {
            var urlString = APIEndpoints.currentWeatherURL
            urlString += "q=\(refinedCityString)&"
            urlString += "appid=\(APIEndpoints.apiKey)&"
            urlString += "units=metric"
            let weather = try await networkManager.fetchWeather(urlStr: urlString)
            userDef.set(weather.name, forKey: "city")
            DispatchQueue.main.async { [weak self] in
                self?.weatherDisplay = weather
            }
        } catch let error {
            print("Could not fetch weather using City Name due to: \(error.localizedDescription)")
        }
    }
    
    func locationFail() {
        print("Location Fetch failed")
    }
    
    func locationUpdate(lat: Double, lon: Double) {
        Task {
            await weatherForCoordinates(lat: lat, lon: lon)
        }
    }
}
