//
//  ServiceErrors.swift
//  WeatherTrackerApp
//
//  Created by Angelber Castro on 16/1/25.
//

import Foundation

class ErrorHandler {
    static func handleError(_ error: Error) -> ServiceErrors {
        if let serviceError = error as? ServiceErrors {
            return serviceError
        }
        return .customMessage("An error occurred with the server")
    }
}

enum ServiceErrors: Error {
    case apiError(Int, Data)
    case networkError
    case decodingError
    case customMessage(String)

    var localizedDescription: String {
        switch self {
        case .apiError:
            return "There was a problem communicating with the server."
        case .networkError:
            return "Network error. Please try again later."
        case .decodingError:
            return "Error processing server response. Please try again later"
        case .customMessage(let message):
            return message
        }
    }
}
