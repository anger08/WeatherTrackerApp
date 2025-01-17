//
//  WeatherRepositoryImpl.swift
//  WeatherTrackerApp
//
//  Created by Angelber Castro on 16/1/25.
//

import Combine
import Factory

class WeatherRepositoryImpl: WeatherRepository {
    var remote = Container.WeatherRemoteDataSource

    func getWeather(key: String, query: String, aqi: String) -> AnyPublisher<WeatherResponse, ServiceErrors> {
        remote.getWeather(key: key, query: query, aqi: aqi)
    }
}
