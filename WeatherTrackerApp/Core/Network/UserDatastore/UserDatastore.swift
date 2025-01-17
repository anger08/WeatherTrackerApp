//
//  UserDatastore.swift
//  WeatherTrackerApp
//
//  Created by Angelber Castro on 16/1/25.
//

import Foundation
import Combine

class UserDatastore {
    private let weatherKey = "weather"

        // Save weather
        func storeWeather(_ weather: WeatherDt) {
            if let encoded = try? JSONEncoder().encode(weather) {
                UserDefaults.standard.set(encoded, forKey: weatherKey)
            }
        }

        // Recovering weather
        func getWeather() -> WeatherDt? {
            if let data = UserDefaults.standard.data(forKey: weatherKey),
               let decoded = try? JSONDecoder().decode(WeatherDt.self, from: data) {
                return decoded
            }
            return nil
        }

        // Delete weather saved
        func deleteWeather() {
            UserDefaults.standard.removeObject(forKey: weatherKey)
        }
}

struct WeatherDt: Codable {
    let weatherData: WeatherResponse
}
