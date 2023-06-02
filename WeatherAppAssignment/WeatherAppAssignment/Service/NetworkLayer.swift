//
//  NetworkLayer.swift
//  WeatherProject
//
//  Created by Kevin Varghese on 5/31/23.
//

import Foundation

protocol NetworkRepresentable {
    func fetchWeather(urlStr: String) async throws -> WeatherModel
}

final class NetworkLayer: NetworkRepresentable {
    private lazy var decoder = JSONDecoder()
    
    func fetchWeather(urlStr: String) async throws -> WeatherModel {
        guard let url = URL(string: urlStr) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession(configuration: .ephemeral).data(from: url)
        guard let urlResponse = response as? HTTPURLResponse else {
            throw URLError(.cannotParseResponse)
        }
        guard (200...299).contains(urlResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try decoder.decode(WeatherModel.self, from: data)
    }
}
