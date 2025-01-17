//
//  UserDatastoreContainer.swift
//  WeatherTrackerApp
//
//  Created by Angelber Castro on 16/1/25.
//

import Factory
import Foundation

extension Container {
    static var datastore: UserDatastore { UserDatastore() }
}
