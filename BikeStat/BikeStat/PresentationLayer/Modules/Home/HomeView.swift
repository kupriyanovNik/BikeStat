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
    @State private var isNewRideCardVisible: Bool = true

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVStack {
                newRideCard()

                Text("История поездок")
                    .font(.title2)
                    .bold()
                    .hLeading()

                ForEach(coreDataManager.allRides.reversed(), id: \.objectID)  { ride in
                    rideInfoCard(ride: ride)
                        .id(ride.objectID)
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
            RideInfoView(ride: ride)
                .presentationDetents([.fraction(0.4)])
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

            if !isNewRideCardVisible {
                Button {
                    navigationManager.path.append("NEW RIDE")
                } label: {
                    Image(systemName: Images.plus)
                        .foregroundStyle(.white)
                }
                .buttonStyle(MainButtonStyle())
                .foregroundStyle(.black)
                .padding(3)
                .background {
                    Color(hex: 0xB180C8)
                        .clipShape(Circle())
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .buttonStyle(MainButtonStyle())
        .font(.largeTitle)
        .padding(.horizontal)
        .padding(.bottom, 4)
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .animation(.linear, value: isNewRideCardVisible)
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
        .onDisappear {
            if navigationManager.path.isEmpty {
                isNewRideCardVisible = false
            }
        }
        .onAppear {
            isNewRideCardVisible = true
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

            Text(String(format: "%.2f", Double(ride.distance) / 1000.0)+" км")
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
