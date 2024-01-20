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

                Text(Localizable.HomeView.rideHistory)
                    .font(.title2)
                    .bold()
                    .hLeading()

                ForEach(coreDataManager.endedRides.reversed(), id: \.objectID)  { ride in
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
        .safeAreaInset(edge: .bottom, content: newRideButton)
        .onAppear {
            coreDataManager.fetchEndedRides()
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
        .animation(.linear, value: isNewRideCardVisible)
    }

    @ViewBuilder func newRideCard() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(Localizable.HomeView.newRide)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Button {
                    navigationManager.path.append(Strings.Navigation.newRide)
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

            Image(systemName: Images.bike)
                .resizable()
                .frame(width: 130, height: 82)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Pallete.accentColor)
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

    @ViewBuilder func newRideButton() -> some View {
        Group {
            if !isNewRideCardVisible {
                Button {
                    navigationManager.path.append(Strings.Navigation.newRide)
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
        .animation(.easeIn, value: isNewRideCardVisible)
    }

    @ViewBuilder func rideInfoCard(ride: RideInfoModel) -> some View {
        let rideDate = ride.rideDate ?? .now

        HStack {
            VStack {
                Text(Localizable.HomeView.ride)

                Text(rideDate.formatted(date: .abbreviated, time: .omitted))
            }
            .font(.title2)
            .bold()

            Spacer()

            Text(
                String(
                    format: Strings.NumberFormats.forDistance,
                    Double(ride.distance) / 1000.0
                ) + " км"
            )
            .font(.largeTitle)
            .bold()
        }
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
