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
    @State private var isPlanRideCardVisible: Bool = true

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVStack {
                planRideCard()
                showHistoryCard()

                Text(Localizable.HomeView.plannedRides)
                    .font(.title2)
                    .bold()
                    .hLeading()

                ForEach(coreDataManager.plannedRides.reversed(), id: \.objectID)  { ride in
                    plannedRideInfoCard(ride: ride)
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
        .safeAreaInset(edge: .bottom, content: planRideButton)
        .onAppear {
            // TODO: - fetch planned rides
        }
        .scaleEffect(selectedRide == nil ? 1 : 0.95)
        .sheet(item: $selectedRide) { ride in
            RideInfoView(ride: ride) {
                withAnimation {
                    coreDataManager.removeRide(ride: ride)
                }
            }
            .presentationDetents([.fraction(0.4)])
        }
        .animation(.easeIn, value: selectedRide)
    }

    // MARK: - ViewBuilders

    @ViewBuilder func headerView() -> some View {
        HStack {
            Text(Localizable.HomeView.pageTitle)
                .bold()

            Spacer()

            Button {
                navigationManager.path.append(Strings.Navigation.settings)
            } label: {
                Image(systemName: Images.gearshape)
            }
            .buttonStyle(MainButtonStyle())
        }
        .foregroundStyle(.black)
        .font(.largeTitle)
        .padding(.horizontal)
        .padding(.bottom, 4)
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .animation(.linear, value: isPlanRideCardVisible)
    }

    @ViewBuilder func planRideCard() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(Localizable.HomeView.planRide)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Button {
                    // TODO: - show planning view
                } label: {
                    Text(Localizable.HomeView.start)
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

            Image(systemName: Images.mountain)
                .resizable()
                .frame(width: 133, height: 60)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Pallete.accentColor)
        }
        .onDisappear {
            if navigationManager.path.isEmpty {
                isPlanRideCardVisible = false
            }
        }
        .onAppear {
            isPlanRideCardVisible = true
        }
    }

    @ViewBuilder func showHistoryCard() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(Localizable.HomeView.rideHistory)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Button {
                    // TODO: - show planning view
                } label: {
                    Text(Localizable.HomeView.goto)
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
                .frame(width: 133, height: 82)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Pallete.showHistoryColor)
        }
        .onDisappear {
            if navigationManager.path.isEmpty {
                isPlanRideCardVisible = false
            }
        }
        .onAppear {
            isPlanRideCardVisible = true
        }
    }

    @ViewBuilder func planRideButton() -> some View {
        Group {
            if !isPlanRideCardVisible {
                Button {
                    // TODO: - show planning view
                } label: {
                    Image(systemName: Images.plus)
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                }
                .buttonStyle(MainButtonStyle())
                .foregroundStyle(.black)
                .padding(10)
                .frame(width: 70, height: 70)
                .background {
                    Pallete.accentColor
                        .clipShape(Circle())
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeIn, value: isPlanRideCardVisible)
    }

    @ViewBuilder func plannedRideInfoCard(ride: RideInfoModel) -> some View {
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
    HomeView(
        homeViewModel: .init(),
        coreDataManager: .init(),
        networkManager: .init(),
        navigationManager: .init()
    )
}
