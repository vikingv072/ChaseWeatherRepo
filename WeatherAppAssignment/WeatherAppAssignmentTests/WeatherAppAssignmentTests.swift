//
//  WeatherAppAssignmentTests.swift
//  WeatherAppAssignmentTests
//
//  Created by Kevin Varghese on 6/1/23.
//

import XCTest
@testable import WeatherAppAssignment

final class WeatherAppAssignmentTests: XCTestCase {
        
    func testWeatherForCity() async throws {
        // Create the mock objects
        let networkManager = MockNetworkLayer()
        let locationManager = MockLocationManager()
        
        // Set up the mock objects as needed
        let expectedWeather = try! JSONDecoder().decode(WeatherModel.self, from: MockParams.data)
        networkManager.weatherToReturn = expectedWeather
        
        // Create an instance of the ViewModel using the mock objects
        let viewModel = ViewModel(networkManager: networkManager, locationManager: locationManager)
        
        // Call the method under test
        await viewModel.weatherForCity(city: "New York")
        
        guard let weatherDisplay = viewModel.weatherDisplay else { return }
        // Assert that the appropriate methods are called
        XCTAssertTrue(networkManager.fetchWeatherCalled, "fetchWeather should be called")
        XCTAssertTrue(locationManager.locationRetrieveCalled, "locationRetrieve should be called")
        
        // Assert that the weatherDisplay property is updated correctly
        XCTAssertEqual(weatherDisplay, expectedWeather, "weatherDisplay should be updated with the expected weather")
        
        // Assert that the city is saved in UserDefaults
        XCTAssertEqual(UserDefaults.standard.string(forKey: "city"), "New York", "City name should be saved in UserDefaults")
    }

    func testWeatherForCoordinates() async throws {
        // Create the mock objects
        let networkManager = MockNetworkLayer()
        let locationManager = MockLocationManager()
        
        // Set up the mock objects as needed
        let expectedWeather = try! JSONDecoder().decode(WeatherModel.self, from: MockParams.data)
        networkManager.weatherToReturn = expectedWeather
        
        // Create an instance of the ViewModel using the mock objects
        let viewModel = ViewModel(networkManager: networkManager, locationManager: locationManager)
        
        // Call the method under test
        await viewModel.weatherForCoordinates(lat: 40.7143, lon: -74.006)
        
        guard let weatherDisplay = viewModel.weatherDisplay else { return }
        // Assert that the appropriate methods are called
        XCTAssertTrue(networkManager.fetchWeatherCalled, "fetchWeather should be called")
        XCTAssertTrue(locationManager.locationRetrieveCalled, "locationRetrieve should be called")
        
        // Assert that the weatherDisplay property is updated correctly
        XCTAssertEqual(weatherDisplay, expectedWeather, "weatherDisplay should be updated with the expected weather")
        
        // Assert that the city is saved in UserDefaults
        XCTAssertEqual(UserDefaults.standard.string(forKey: "city"), "New York", "City name should be saved in UserDefaults")
    }
}
