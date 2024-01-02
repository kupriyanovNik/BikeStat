//
//  NavigationManager.swift
//

import Foundation

class NavigationManager: ObservableObject {
    
    // MARK: - Property Wrappers

    @Published var shouldShowRideScreen: Bool = false
    @Published var shouldShowRideInfoScreen: Bool = false
}
