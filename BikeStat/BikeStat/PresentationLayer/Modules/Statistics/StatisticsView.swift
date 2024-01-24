//
//  StatisticsView.swift
//

import SwiftUI

struct StatisticsView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var coreDataManager: CoreDataManager

    // MARK: - Private Properties

    private var last7Rides: [RideInfoModel] {
        coreDataManager.endedRides.suffix(7)
    }

    private var shouldShowStatistics: Bool {
        !coreDataManager.endedRides.isEmpty
    }

    private var shouldShowRecomendations: Bool {
        last7Rides.count > 7
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            if shouldShowStatistics {
                Text("yes")
            } else {
                Text("no")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top, content: headerView)
    }

    // MARK: - View Builders

    @ViewBuilder func headerView() -> some View {
        Text("Статистика")
            .makeHeader {
                dismiss()
            }
    }
}

// MARK: - Preview

#Preview {
    StatisticsView(
        coreDataManager: .init()
    )
}
