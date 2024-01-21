//
//  HomeView.swift
//

import SwiftUI

struct HomeView: View {

    // MARK: - Property Wrappers

    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var rideViewModel: RideViewModel
    @ObservedObject var planningViewModel: PlanningViewModel
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var navigationManager: NavigationManager

    @State private var isPlanRideCardVisible: Bool = true

    // MARK: - Body

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    VStack {
                        planRideCard()

                        if !coreDataManager.endedRides.isEmpty {
                            showHistoryCard()
                        }
                    }
                    .padding(.bottom, 5)

                    Text(Localizable.HomeView.plannedRides)
                        .font(.title2)
                        .bold()
                        .hLeading()
                        .id("TOP")

                    plannedRidesList()
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .top, content: headerView)
            .safeAreaInset(edge: .bottom, content: planRideButton)
            .onAppear {
                coreDataManager.fetchPlannedRides()
            }
            .overlay {
                if homeViewModel.shouldShowRidePlanningView {
                    Color.black
                        .opacity(0.15)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                homeViewModel.shouldShowRidePlanningView = false
                            }
                        }

                    planningViewPopup(proxy: proxy)
                        .transition(.move(edge: .top))
                }
            }
        }
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
                    withAnimation {
                        homeViewModel.shouldShowRidePlanningView = true
                    }
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
                    navigationManager.path.append(
                        Strings.Navigation.history
                    )
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
                    withAnimation {
                        homeViewModel.shouldShowRidePlanningView.toggle()
                    }
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

    @ViewBuilder func planningViewPopup(proxy: ScrollViewProxy) -> some View {
        VStack {
            PlanningView(
                planningViewModel: planningViewModel,
                homeViewModel: homeViewModel,
                coreDataManager: coreDataManager
            ) {
                proxy.scrollTo("TOP", anchor: .top)
            }

            Spacer()
        }
        .animation(
            .easeIn,
            value: homeViewModel.shouldShowRidePlanningView
        )
    }

    @ViewBuilder func plannedRidesList() -> some View {
        ForEach(
            coreDataManager.plannedRides.reversed(),
            id: \.objectID
        )  { ride in
            plannedRideInfoCard(ride: ride)
                .id(ride.objectID)
                .onTapGesture {
                    navigationManager.path.append(
                        Strings.Navigation.newRide
                    )
                    rideViewModel.currentRide = ride
                }
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView(
        homeViewModel: .init(),
        rideViewModel: .init(),
        planningViewModel: .init(),
        coreDataManager: .init(),
        networkManager: .init(),
        navigationManager: .init()
    )
}
