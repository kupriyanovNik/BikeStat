//
//  HistoryView.swift
//

import SwiftUI

struct HistoryView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var coreDataManager: CoreDataManager

    @State private var selectedRide: RideInfoModel?

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(
                    coreDataManager.endedRides,
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
            RideInfoView(ride: ride) {
                withAnimation {
                    coreDataManager.removeRide(ride: ride)
                }

                if coreDataManager.endedRides.isEmpty {
                    dismiss()
                }
            }
            .presentationDetents([.fraction(0.4)])
        }
        .animation(.easeIn, value: selectedRide)
    }

    // MARK: - View Builders

    @ViewBuilder func headerView() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: Images.back)
                    .font(.title2)
                    .bold()
            }

            Spacer()

            Text("История поездок")
                .font(.largeTitle)
                .bold()

            Spacer()
        }
        .foregroundStyle(.black)
        .font(.largeTitle)
        .padding(.horizontal)
        .padding(.bottom, 4)
        .background {
            Color.white
                .ignoresSafeArea()
        }
    }

    @ViewBuilder func endedRideInfoCard(ride: RideInfoModel) -> some View {
        let rideDate = ride.rideDate ?? .now

        HStack {
            Text(ride.title ?? "Default Name")

            Spacer()

            VStack {
                Text(rideDate.formatted(date: .abbreviated, time: .omitted))
                Text(rideDate.formatted(date: .omitted, time: .shortened))
            }
        }
        .font(.title2)
        .fontWeight(.semibold)
        .padding()
        .background {
            Pallete.Complexity
                .getRandomColor()
                .cornerRadius(25)
        }
    }
}

// MARK: - Preview

#Preview {
    HistoryView(
        coreDataManager: .init()
    )
}
