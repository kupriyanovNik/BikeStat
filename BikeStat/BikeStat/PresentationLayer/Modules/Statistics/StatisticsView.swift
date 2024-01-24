//
//  StatisticsView.swift
//

import SwiftUI

struct StatisticsView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var coreDataManager: CoreDataManager

    // MARK: - Body

    var body: some View {
        VStack {
            Spacer()
        }
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
