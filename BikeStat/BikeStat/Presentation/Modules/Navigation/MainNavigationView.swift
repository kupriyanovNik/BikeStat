//
//  MainNavigationView.swift
//

import SwiftUI

struct MainNavigationView: View {

    // MARK: - Property Wrappers

    @ObservedObject var navigationManager: NavigationManager

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            HomeView()
        }
    }
}

// MARK: - Preview 

#Preview {
    MainNavigationView(
        navigationManager: .init()
    )
}
