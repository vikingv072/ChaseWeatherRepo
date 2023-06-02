//
//  InformationDisplay.swift
//  WeatherAppAssignment
//
//  Created by Kevin Varghese on 6/1/23.
//

import SwiftUI

struct InformationDisplay: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            imageDisplayView
            displayDetailsView
        }
    }
    
    var imageDisplayView: some View {
        //View for icon/image
        VStack {
            if let iconId = viewModel.weatherDisplay?.weather?.first?.icon {
                let urlString = "https://openweathermap.org/img/wn/\(iconId)@2x.png"
                if let url = URL(string: urlString) {
                    AsyncImage(url: url, content: { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120 , height: 120)
                    }, placeholder: {
                        ProgressView()
                    })
                }
            }
        }
    }
    
    var displayDetailsView: some View {
        VStack(spacing: 20) {
            // Views for other details
            if let name = viewModel.weatherDisplay?.name {
                Text(name)
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                    .foregroundColor(.teal)
            }
            if let temp = viewModel.weatherDisplay?.main?.temp {
                infoView(param: "Temperature:", value: convertToFahrenheit(temp))
            }
            if let feelsLike = viewModel.weatherDisplay?.main?.feels_like {
                infoView(param: "Feels Like:", value: convertToFahrenheit(feelsLike))
            }
            if let windSpeed = viewModel.weatherDisplay?.wind?.speed {
                infoView(param: "Wind Speed:", value: showWindSpeed(windSpeed))
            }
            if let humidity = viewModel.weatherDisplay?.main?.humidity {
                infoView(param: "Humidity:", value: showHumidity(humidity))
            }
        }
    }
    
    func infoView(param: String, value: String) -> some View {
        HStack {
            Text(param)
                .font(.system(size: 24))
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .font(.system(size: 24))
                .fontWeight(.medium)
        }
        .padding(.horizontal, 25)
    }
}

struct InformationDisplay_Previews: PreviewProvider {
    static var previews: some View {
        InformationDisplay(viewModel: ViewModel(networkManager: MockNetworkLayer(),
                                                locationManager: MockLocationManager()))
    }
}
