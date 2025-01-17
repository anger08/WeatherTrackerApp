//
//  MainViewModel.swift
//  WeatherTrackerApp
//
//  Created by Angelber Castro on 16/1/25.
//

import Combine
import Factory
import SwiftUI
import Foundation

class MainViewModel: ObservableObject {
    @Published var weatherResponse: WeatherResponse?
    @Published var weatherMessage: String? = "No City Selected"
    @Published var isSearching: Bool = false
    @Published var query: String = "" {
        didSet {
            performSearch(query: query)
        }
    }

    var datastore = Container.datastore
    var weatherUseCase = Container.getWeatherUseCase
    var disposables: Set<AnyCancellable> = Set()
    private var currentTask: AnyCancellable? // To cancel the current search

    init() {
        // Load saved weather on startup
        loadSavedWeather()
    }

    private func performSearch(query: String) {
        // Validate that the text has at least 3 characters
        guard query.count >= 3 else {
            weatherResponse = nil
            weatherMessage = query.isEmpty ? "No City Selected" : "Please enter at least 3 characters."
            isSearching = false
            return
        }

        // We cancel the ongoing search if it exists
        currentTask?.cancel()

        // We carry out the search
        let apiKey = URLDomains.shared.ApiKey
        let aqi = "no"

        isSearching = true // We activate the search status
        currentTask = weatherUseCase.invoke(key: apiKey, query: query, aqi: aqi)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("Successful query")
                case .failure(let error):
                    self.weatherResponse = nil
                    self.weatherMessage = "Invalid city: \(query)"
                    self.isSearching = false
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.weatherResponse = response
                self.weatherMessage = nil
                self.isSearching = true
                print("Response received: \(response)")
            })
    }

    func selectCity() {
        guard let weather = weatherResponse else { return }

        // Save the selected city in UserDefaults
        let weatherSaved = WeatherDt(weatherData: weather)

        datastore.storeWeather(weatherSaved)

        // We hide the "result card" and update the main view
        isSearching = false
    }

    private func loadSavedWeather() {
        // Load weather saved
        if let savedWeather = datastore.getWeather() {
            weatherResponse = WeatherResponse(
                location: Location(name: savedWeather.weatherData.location.name),
                current: Current(
                    tempC: savedWeather.weatherData.current.tempC,
                    condition: Condition(text: savedWeather.weatherData.current.condition.text, icon: savedWeather.weatherData.current.condition.icon, code: savedWeather.weatherData.current.condition.code),
                    humidity: savedWeather.weatherData.current.humidity,
                    uv: savedWeather.weatherData.current.uv,
                    feelslikeC: savedWeather.weatherData.current.feelslikeC
                )
            )
            weatherMessage = nil
        } else {
            weatherMessage = "No City Selected"
        }
    }
}
