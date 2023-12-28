//
//  HomeView.swift
//

import SwiftUI

struct HomeView: View {

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
    HomeView()
}
