//
//  WeatherRemoteDtaSourceImpl.swift
//  WeatherTrackerApp
//
//  Created by Angelber Castro on 16/1/25.
//

import Alamofire
import Foundation
import Combine

class WeatherRemoteDataSourceImpl: WeatherRemoteDataSource {
    func getWeather(key: String, query: String, aqi: String) -> AnyPublisher<WeatherResponse, ServiceErrors> {
        let url = URL(string: "\(URLDomains.shared.BASE)?key=\(key)&q=\(query)&aqi=\(aqi)")!

        return AF.request(url, method: .get)
            .publishData()
            .tryMap { dataResponse -> Data in
                guard let statusCode = dataResponse.response?.statusCode else {
                    throw URLError(.badServerResponse)
                }
                if 200..<300 ~= statusCode {
                    return dataResponse.data ?? Data()
                } else {
                    throw ServiceErrors.apiError(statusCode, dataResponse.data ?? Data())
                }
            }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .mapError { error -> ServiceErrors in
                return ErrorHandler.handleError(error)
            }
            .eraseToAnyPublisher()
    }
}
