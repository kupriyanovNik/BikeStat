//
//  ThemeManager.swift
//

import SwiftUI

class ThemeManager: ObservableObject {

    // MARK: - Property Wrappers

    @Published private(set) var selectedTheme: Theme = Theme1()

    @AppStorage("THEME_SlectedTheme") private(set) var selectedThemeIndex: Int = 0 {
        willSet {
            objectWillChange.send()
        }

        didSet {
            updateTheme()
        }
    }
    
    // MARK: - Inits

    init() {
        updateTheme()
    }

    // MARK: - Internal Functions

    func setThemeIndet(at index: Int) {
        withAnimation {
            selectedThemeIndex = index
        }
    }

    // MARK: - Private Functions 

    private func updateTheme() {
        selectedTheme = ThemeDataSource.getTheme(themeIndex: selectedThemeIndex)
    }
}
