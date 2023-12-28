//
//  HomeView.swift
//

import SwiftUI

struct HomeView: View {

    // MARK: - Property Wrappers

    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var locationManager: LocationManager

    // MARK: - Body

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

// MARK: - Preview 

#Preview {
    HomeView(
        navigationManager: .init(),
        locationManager: .init()
    )
}
