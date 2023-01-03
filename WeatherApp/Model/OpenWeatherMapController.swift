//
//  OpenWeatherMapController.swift
//  WeatherApp
//
//  Created by Jessi Zimmerman on 10/18/22.
//

import Foundation

private enum API {
    static let key = "bbc3907badebbb33e83f364b7c7459d4"
}

class OpenWeatherMapController: WebServiceController {
    func fetchWeatherData(for city: String, completionHandler: @escaping (String?, WebServiceControllerError?) -> Void ) {
        
        //  https://api.openweathermap.org/data/2.5/weather?lat=57&lon=-2.15&appid=bbc3907badebbb33e83f364b7c7459d4&units=imperial
        let endpoint = "https://api.openweathermap.org/data/2.5/find?q=\(city)&units=imperial&appid=\(API.key)"
        guard let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
              let endpointURL = URL(string: safeURLString) else {
                    completionHandler(nil, WebServiceControllerError.invalidURL(endpoint))
                    return
        }
        let dataTask = URLSession.shared.dataTask(with: endpointURL){(data, response, error) in
            guard error == nil else {
                completionHandler(nil, WebServiceControllerError.forwarded(error!))
                return
            }
            guard let responseData = data else {
                completionHandler(nil, WebServiceControllerError.invalidPayload(endpointURL))
                return
            }
            let decoder = JSONDecoder()
            do {
                let weatherList = try decoder.decode(OpenWeatherMapContainer.self, from: responseData)
                guard let weatherInfo = weatherList.list?.first,
                      let weather = weatherInfo.weather.first?.main,
                      let temperature = weatherInfo.main.temp else {
                        completionHandler(nil, WebServiceControllerError.invalidPayload(endpointURL))
                        return
                }
                let weatherDescription  = "\(weather) \(temperature) °F"
                completionHandler(weatherDescription, nil)
            }
            catch let error {
                completionHandler(nil, WebServiceControllerError.forwarded(error))
            }
        }
        dataTask.resume()
    }
}
