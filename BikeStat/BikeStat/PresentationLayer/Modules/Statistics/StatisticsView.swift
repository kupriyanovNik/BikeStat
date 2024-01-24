//
//  StatisticsView.swift
//

import SwiftUI

struct StatisticsView: View {

    // MARK: - Property Wrappers

    @ObservedObject var coreDataManager: CoreDataManager

    // MARK: - Body

    var body: some View {
        Text("Hello, World!")
    }
}

// MARK: - Preview

#Preview {
    StatisticsView(
        coreDataManager: .init()
    )
}
