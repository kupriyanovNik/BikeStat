//
//  PlanningView.swift
//

import SwiftUI

struct PlanningView: View {

    // MARK: - Property Wrappers

    @ObservedObject var planningViewModel: PlanningViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var coreDataManager: CoreDataManager

    // MARK: - Internal Properties

    var addingAction: (() -> ())? = nil

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            TextField(
                "Введите название поездки:",
                text: $planningViewModel.rideTitle
            )
            .onTapContinueEditing()

            HStack {
                Text("Выберите время поездки:")

                Spacer()

                DatePicker(
                    "",
                    selection: $planningViewModel.rideDate,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
            }

            HStack {
                Text("Выберите дату поездки:")

                Spacer()

                DatePicker(
                    "",
                    selection: $planningViewModel.rideDate,
                    displayedComponents: .date
                )
                .labelsHidden()
            }

            HStack {
                Text("Выберите время\nнахождения в поездке:")

                Spacer()

                Picker(
                    "",
                    selection: $planningViewModel.estimatedTime
                ) {
                    ForEach(
                        Array(stride(from: 5, to: 300, by: 5)),
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
                Text("Выберите длину маршрута:")

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
                                format: Strings.NumberFormats.forDistanceShort,
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
                Text("Сохранить")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 23)
                    .background(.white)
                    .cornerRadius(40)
            }
            .buttonStyle(MainButtonStyle())
            .hCenter()
        }
        .padding()
        .safeAreaInset(edge: .top, content: headerView)
        .foregroundStyle(.black)
        .font(.title2)
        .background {
            Pallete.accentColor
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
        Text("Планирование\nпоездки")
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .bold()
            .hCenter()
            .overlay(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: Images.back)
                        .font(.title2)
                        .bold()
                        .padding()
                }
            }
    }

    // MARK: - Private Functions

    private func dismiss() {
        withAnimation {
            homeViewModel.shouldShowRidePlanningView = false
        }
    }

    private func planRide() {
        withAnimation {
            addingAction?()

            coreDataManager.planRide(
                title: planningViewModel.rideTitle,
                rideDate: planningViewModel.rideDate,
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
        coreDataManager: .init()
    )
}
