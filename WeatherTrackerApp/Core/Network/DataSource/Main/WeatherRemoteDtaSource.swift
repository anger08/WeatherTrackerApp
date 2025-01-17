//
//  WeatherRemoteDtaSource.swift
//  WeatherTrackerApp
//
//  Created by Angelber Castro on 16/1/25.
//

import Combine

protocol WeatherRemoteDataSource {
    func getWeather(key: String, query: String, aqi: String) -> AnyPublisher<WeatherResponse, ServiceErrors>
}
