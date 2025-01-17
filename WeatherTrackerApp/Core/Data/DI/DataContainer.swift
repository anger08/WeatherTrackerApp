//
//  DataContainer.swift
//  WeatherTrackerApp
//
//  Created by Angelber Castro on 16/1/25.
//

import Factory

extension Container {
    static var weatherRepository: WeatherRepository { WeatherRepositoryImpl() }
}
