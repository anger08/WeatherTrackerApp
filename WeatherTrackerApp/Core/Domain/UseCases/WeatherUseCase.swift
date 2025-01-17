//
//  WeatherUseCase.swift
//  WeatherTrackerApp
//
//  Created by Angelber Castro on 16/1/25.
//

import Factory
import Combine

class WeatherUseCase {
    var repo = Container.weatherRepository

    func invoke(key: String, query: String, aqi: String) -> AnyPublisher<WeatherResponse, ServiceErrors> {
        return repo.getWeather(key: key, query: query, aqi: aqi)
    }
}
