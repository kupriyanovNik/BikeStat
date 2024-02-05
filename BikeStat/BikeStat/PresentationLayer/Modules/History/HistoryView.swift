//
//  HistoryView.swift
//

import SwiftUI

struct HistoryView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var themeManager: ThemeManager

    @State private var selectedRide: RideInfoModel?

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(
                    coreDataManager.endedRides.reversed(),
                    id: \.objectID
                ) { ride in
                    endedRideInfoCard(ride: ride)
                        .id(ride.objectID)
                        .onTapGesture {
                            withAnimation {
                                selectedRide = ride 
                            }
                        }
                        .padding(.horizontal)
                }
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top, content: headerView)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .scaleEffect(selectedRide == nil ? 1 : 0.95)
        .sheet(item: $selectedRide) { ride in
            RideInfoView(
                settingsViewModel: settingsViewModel,
                themeManager: themeManager,
                ride: ride
            ) {
                withAnimation {
                    coreDataManager.removeRide(ride: ride)
                }

                if coreDataManager.endedRides.isEmpty {
                    dismiss()
                }

                ImpactManager.shared.generateFeedback(style: .heavy)
            }
            .presentationDetents([.fraction(0.45)])
        }
        .animation(.easeIn, value: selectedRide)
    }

    // MARK: - View Builders

    @ViewBuilder func headerView() -> some View {
        Text(Localizable.History.pageTitle)
            .makeHeader {
                dismiss()
            }
            .onTapGesture(count: 3) {
                withAnimation {
                    coreDataManager.removeAllEndedRides()
                }
            }
    }

    @ViewBuilder func endedRideInfoCard(ride: RideInfoModel) -> some View {
        let rideDate = ride.rideDate.safeUnwrap()

        HStack {
            Text(ride.title.safeUnwrap())

            Spacer()

            VStack {
                Text(rideDate.formatted(date: .abbreviated, time: .omitted))
                Text(rideDate.formatted(date: .omitted, time: .shortened))
            }
        }
        .foregroundStyle(.black)
        .font(.title2)
        .fontWeight(.semibold)
        .padding()
        .background {
            ComplexityManager.shared
                .getColorByComplexity(
                    complexity: ride.realComplexity
                )
                .cornerRadius(25)
        }
    }
}

// MARK: - Preview

#Preview {
    HistoryView(
        settingsViewModel: .init(),
        coreDataManager: .init(),
        themeManager: .init()
    )
}
