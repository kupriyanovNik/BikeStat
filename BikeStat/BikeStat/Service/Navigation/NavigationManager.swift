//
//  NavigationManager.swift
//

import Foundation

final class NavigationManager: ObservableObject {
    
    // MARK: - Property Wrappers

    @Published var path: [NavigationModel] = []
}
