//
//  PlanningView.swift
//

import SwiftUI

struct PlanningView: View {

    // MARK: - Property Wrappers

    @ObservedObject var planningViewModel: PlanningViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var themeManager: ThemeManager

    // MARK: - Private Properties

    private let complexityManager = ComplexityManager.shared

    private var currentComplexity: RideComplexity {
        complexityManager.getEstimatedComplexity(
            estimatedDistance: planningViewModel.estimatedDistance,
            estimatedTime: planningViewModel.estimatedTime * 60
        )
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            TextField(
                Localizable.Planning.enterRideTitle,
                text: $planningViewModel.rideTitle
            )
            .onTapContinueEditing()

            HStack {
                Text(Localizable.Planning.selectTime)

                Spacer()

                DatePicker(
                    "",
                    selection: $planningViewModel.rideDate,
                    in: Date()..., 
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
            }

            HStack {
                Text(Localizable.Planning.selectDate)

                Spacer()

                DatePicker(
                    "",
                    selection: $planningViewModel.rideDate,
                    displayedComponents: .date
                )
                .labelsHidden()
            }

            HStack {
                Text(Localizable.Planning.selectTimeDuringRide)

                Spacer()

                Picker(
                    "",
                    selection: $planningViewModel.estimatedTime
                ) {
                    ForEach(
                        Array(stride(from: 1, to: 300, by: 1)),
                        id: \.self
                    ) { number in
                        Text("\(number) мин")
                            .id(number)
                            .tag(number)
                    }
                }
                .tint(.black)
                .labelsHidden()
            }

            HStack {
                Text(Localizable.Planning.selectDistance)

                Spacer()

                Picker(
                    "",
                    selection: $planningViewModel.estimatedDistance
                ) {
                    ForEach(
                        Array(stride(from: 1000, to: 30000, by: 500)),
                        id: \.self
                    ) { number in
                        Text(
                            String(
                                format: .shortDistanceFormat,
                                Double(number) / 1000.0
                            ) + " км"
                        )
                        .id(number)
                        .tag(number)
                    }
                }
                .tint(.black)
                .labelsHidden()
            }

            Button {
                planRide()
            } label: {
                Text(Localizable.Planning.save)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 23)
                    .background(.white)
                    .cornerRadius(40)
                    .shadow(
                        color: .white.opacity(0.2),
                        radius: 20
                    )
            }
            .buttonStyle(MainButtonStyle())
            .hCenter()
        }
        .padding()
        .safeAreaInset(edge: .top, content: headerView)
        .foregroundStyle(.black)
        .font(.title2)
        .background {
            themeManager.selectedTheme.accentColor
                .clipShape(
                    RoundedShape(
                        corners: [.bottomLeft, .bottomRight],
                        radius: 15
                    )
                )
                .ignoresSafeArea()
        }
        .onTapEndEditing()
    }

    // MARK: - View Builders

    @ViewBuilder func headerView() -> some View {
        Text(Localizable.Planning.pageTitle)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .bold()
            .hCenter()
            .overlay(alignment: .top) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: Images.back)
                            .font(.title2)
                            .bold()
                    }

                    Spacer()

                    Circle()
                        .strokeBorder(Color.black, lineWidth: 2)
                        .frame(width: 30, height: 30)
                        .background {
                            Circle()
                                .fill(
                                    currentComplexity.estimatedComplexityColor
                                )
                        }
                        .shadow(
                            color: currentComplexity.estimatedComplexityColor,
                            radius: 20
                        )
                        .animation(.linear, value: currentComplexity)
                }
                .padding()
            }
    }

    // MARK: - Private Functions

    private func dismiss() {
        planningViewModel.reset()

        withAnimation {
            homeViewModel.shouldShowRidePlanningView = false
        }
    }

    private func planRide() {
        let rideTitle = planningViewModel.rideTitle
        let rideDate = planningViewModel.rideDate
        let rideDistance = planningViewModel.estimatedDistance
        let parsedDistance = String(format: .shortDistanceFormat, Double(rideDistance) / 1000)

        let notificationTitleWithDistance = rideTitle + " (\(parsedDistance) км)"
        NotificationManager.shared.sendNotification(subtitle: notificationTitleWithDistance, date: rideDate)

        withAnimation {
            coreDataManager.planRide(
                title: rideTitle,
                rideDate: rideDate,
                estimatedTime: planningViewModel.estimatedTime * 60,
                estimatedDistance: planningViewModel.estimatedDistance,
                estimatedComplexity: ComplexityManager.shared.getEstimatedComplexity(
                    estimatedDistance: planningViewModel.estimatedDistance,
                    estimatedTime: planningViewModel.estimatedTime * 60
                ).rawValue
            )
        }

        dismiss()
    }
}

// MARK: - Preview

#Preview {
    PlanningView(
        planningViewModel: .init(),
        homeViewModel: .init(),
        coreDataManager: .init(),
        themeManager: .init()
    )
}
