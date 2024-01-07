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

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack {
                newRideCard()
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top, content: headerView)
        .onAppear {
            coreDataManager.fetchAllRides()
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func headerView() -> some View {
        HStack {
            Text("BikeStat")
                .bold()

            Spacer()

            Image(systemName: Images.gearshape)
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
                    navigationManager.shouldShowRideScreen = true 
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
                    Color.init(hex: 0xB180C8)
                )
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
