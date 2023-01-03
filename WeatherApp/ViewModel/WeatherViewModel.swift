//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Jessi Zimmerman on 10/18/22.
//

import Foundation

class WeatherViewModel: ObservableObject {
    private let weatherService = OpenWeatherMapController()
    @Published var weatherInfo = ""
    
    func fetch(city: String) {
        weatherService.fetchWeatherData(for: city) {(info, error) in
            guard error == nil,
                  let weatherInfo = info else {
                DispatchQueue.main.async {
                    self.weatherInfo = "Could not retrieve weather information for \(city)."

                }
                return
            }
            DispatchQueue.main.async {
                self.weatherInfo = weatherInfo
            }
        }
    }
}
