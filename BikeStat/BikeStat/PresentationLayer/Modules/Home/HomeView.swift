//
//  HomeView.swift
//

import SwiftUI

struct HomeView: View {

    // MARK: - Property Wrappers

    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var navigationManager: NavigationManager

    @State private var selectedRide: RideInfoModel?

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack {
                newRideCard()

                Text("История поездок")
                    .font(.title2)
                    .bold()
                    .hLeading()

                ForEach(coreDataManager.allRides.reversed(), id: \.objectID)  { ride in
                    rideInfoCard(ride: ride)
                        .onTapGesture {
                            selectedRide = ride
                        }
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top, content: headerView)
        .onAppear {
            coreDataManager.fetchAllRides()
        }
        .sheet(item: $selectedRide) { ride in
            Text((ride.rideDate ?? .now).formatted(date: .abbreviated, time: .omitted))
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func headerView() -> some View {
        HStack {
            Text("BikeStat")
                .bold()

            Spacer()

            Button {
                navigationManager.path.append("SETTINGS")
            } label: {
                Image(systemName: Images.gearshape)
            }
            .foregroundStyle(.black)
        }
        .font(.largeTitle)
        .padding(.horizontal)
        .padding(.bottom)
        .background {
            Color.white
                .ignoresSafeArea()
        }
    }

    @ViewBuilder func newRideCard() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Новая поездка")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Button {
                    navigationManager.path.append("NEW RIDE")
                } label: {
                    Text("Начать")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 23)
                        .background(.white)
                        .cornerRadius(40)
                }
                .buttonStyle(MainButtonStyle(scaleAnchor: .leading))
            }

            Spacer()

            Image(systemName: Images.bike)
                .resizable()
                .frame(width: 130, height: 82)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    Color(hex: 0xB180C8)
                )
        }
    }

    @ViewBuilder func rideInfoCard(ride: RideInfoModel) -> some View {
        let rideDate = ride.rideDate ?? .now

        HStack {
            VStack {
                Text("Поездка")

                Text(rideDate.formatted(date: .abbreviated, time: .omitted))
            }
            .font(.title2)
            .bold()

            Spacer()

            Text("\(ride.distance) км")
                .font(.largeTitle)
                .bold()
        }
        .padding()
        .background {
            Color(hex: 0xFF7979)
                .cornerRadius(25)
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView(
        homeViewModel: .init(),
        coreDataManager: .init(),
        networkManager: .init(),
        navigationManager: .init()
    )
}
