//
//  MockParams.swift
//  WeatherAppAssignment
//
//  Created by Kevin Varghese on 6/1/23.
//

import Foundation


// TODO: - Mock data is all panned out, need to write test cases

class MockParams {
    static let data = """
       {
         "coord": {
           "lon": -74.006,
           "lat": 40.7143
         },
         "weather": [
           {
             "id": 800,
             "main": "Clear",
             "description": "clear sky",
             "icon": "01d"
           }
         ],
         "base": "stations",
         "main": {
           "temp": 27.9,
           "feels_like": 27.64,
           "temp_min": 22.75,
           "temp_max": 33.04,
           "pressure": 1019,
           "humidity": 41
         },
         "visibility": 10000,
         "wind": {
           "speed": 3.09,
           "deg": 40
         },
         "clouds": {
           "all": 0
         },
         "dt": 1685641325,
         "sys": {
           "type": 1,
           "id": 4610,
           "country": "US",
           "sunrise": 1685611643,
           "sunset": 1685665237
         },
         "timezone": -14400,
         "id": 5128581,
         "name": "New York",
         "cod": 200
       }
""".data(using: .utf8)!
}

class MockLocationManager: LocationManagerService {
    var delegate: LocationManagerProtocol?
    var locationRetrieveCalled = false
    
    init() {
        locationRetrieve()
    }
    
    func locationRetrieve() {
        locationRetrieveCalled = true
        delegate?.locationUpdate(lat: 0, lon: 0)
    }
}

class MockNetworkLayer: NetworkRepresentable {
    var weatherToReturn: WeatherModel?
    var fetchWeatherCalled = false
    
    func fetchWeather(urlStr: String) async throws -> WeatherModel {
        fetchWeatherCalled = true
        if let weather = weatherToReturn {
            return weather
        } else {
            throw NSError(domain: "MockNetworkManager", code: 0, userInfo: nil)
        }
    }
}
