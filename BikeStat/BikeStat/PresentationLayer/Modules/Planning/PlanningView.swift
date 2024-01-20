//
//  PlanningView.swift
//

import SwiftUI

struct PlanningView: View {

    // MARK: - Property Wrappers

    @ObservedObject var planningViewModel: PlanningViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var coreDataManager: CoreDataManager

    // MARK: - Body

    var body: some View {
        VStack {
            Text("Планирование поездки")
                .hCenter()
                .overlay(alignment: .leading) {
                    Button {
                        withAnimation {
                            homeViewModel.shouldShowRidePlanningView = false 
                        }
                    } label: {
                        Image(systemName: Images.back)
                            .font(.title2)
                            .bold()
                            .padding()
                    }
                }
        }
        .background {
            Pallete.accentColor
                .ignoresSafeArea()
        }
    }
}

// MARK: - Preview

#Preview {
    PlanningView(
        planningViewModel: .init(),
        homeViewModel: .init(),
        coreDataManager: .init()
    )
}
