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
    @ObservedObject var themeManager: ThemeManager

    @State private var isPlanRideCardVisible: Bool = true

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVStack {
                VStack {
                    planRideCard()

                    if !coreDataManager.endedRides.isEmpty {
                        showHistoryCard()
                    }
                }
                .padding(.bottom, 5)

                if !coreDataManager.plannedRides.isEmpty {
                    Text(Localizable.HomeView.plannedRides)
                        .font(.title2)
                        .bold()
                        .hLeading()
                        .onTapGesture(count: 3) {
                            withAnimation {
                                coreDataManager.removeAllPlannedRides()
                            }
                        }
                }

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

                planningViewPopup()
                    .transition(.move(edge: .top))
            }
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func headerView() -> some View {
        HStack {
            Text(Localizable.HomeView.pageTitle)
                .bold()
                .font(.largeTitle)

            Spacer()

            if !coreDataManager.endedRides.isEmpty {
                Button {
                    navigationManager.showStatisticsView()
                } label: {
                    Circle()
                        .strokeBorder(Color.black, lineWidth: 2)
                        .frame(width: 40, height: 40)
                        .background {
                            Circle()
                                .fill(themeManager.selectedTheme.accentColor)
                        }
                        .overlay {
                            HStack(alignment: .bottom, spacing: 4) {
                                Rectangle()
                                    .fill(Pallete.Complexity.hard)
                                    .frame(width: 4, height: 21)
                                Rectangle()
                                    .fill(Pallete.Complexity.easy)
                                    .frame(width: 4, height: 15)
                                Rectangle()
                                    .fill(Pallete.Complexity.medium)
                                    .frame(width: 4, height: 12)
                            }
                        }
                }
                .buttonStyle(MainButtonStyle())
            }

            Button {
                navigationManager.showSettingsView()
            } label: {
                Image(systemName: Images.gearshape)
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            .buttonStyle(MainButtonStyle())
        }
        .foregroundStyle(Pallete.textColor)
        .padding(.horizontal)
        .padding(.bottom, 4)
        .background {
            Pallete.headerBackground
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
                .fill(themeManager.selectedTheme.accentColor)
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
                    navigationManager.showHistoryView()
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
                    themeManager.selectedTheme.accentColor
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
            ComplexityManager.shared
                .getColorByEstimatedComplexity(
                    complexity: ride.estimatedComplexity
                )
                .cornerRadius(25)
        }
    }

    @ViewBuilder func planningViewPopup() -> some View {
        VStack {
            PlanningView(
                planningViewModel: planningViewModel,
                homeViewModel: homeViewModel,
                coreDataManager: coreDataManager,
                themeManager: themeManager
            )

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
                    navigationManager.showRideView()
                    
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
        navigationManager: .init(),
        themeManager: .init()
    )
}
