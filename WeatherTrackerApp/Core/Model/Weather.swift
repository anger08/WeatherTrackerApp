//
//  Weather.swift
//  WeatherTrackerApp
//
//  Created by Angelber Castro on 16/1/25.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: Current
}

// MARK: - Location
struct Location: Codable {
    let name: String
}

// MARK: - Current
struct Current: Codable {
    let tempC: Double
    let condition: Condition
    let humidity: Int
    let uv: Double
    let feelslikeC: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case humidity
        case uv
        case feelslikeC = "feelslike_c"
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}
