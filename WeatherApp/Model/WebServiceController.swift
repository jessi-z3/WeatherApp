//
//  WebServiceController.swift
//  WeatherApp
//
//  Created by Jessi Zimmerman on 10/17/22.
//

import Foundation
public enum WebServiceControllerError : Error {
    case invalidURL(String)
    case invalidPayload(URL)
    case forwarded(Error)
}
public protocol WebServiceController {
    func fetchWeatherData(for city: String,
                          completionHandler: @escaping (String?, WebServiceControllerError?) -> Void)
}
