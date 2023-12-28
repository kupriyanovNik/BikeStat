//
//  BikeStatApp.swift
//  BikeStat
//
//  Created by Никита Куприянов on 26.12.2023.
//

import SwiftUI

@main
struct BikeStatApp: App {

    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var networkManager = NetworkManager()
    @StateObject private var coreDataManager = CoreDataManager()
    @StateObject private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            MainNavigationView()
        }
    }
}
