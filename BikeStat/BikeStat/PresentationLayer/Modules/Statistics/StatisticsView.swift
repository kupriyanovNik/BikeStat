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
            .hCenter()
            .overlay(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: Images.back)
                        .padding()
                }
            }
    }
}

// MARK: - Preview

#Preview {
    StatisticsView(
        coreDataManager: .init()
    )
}
