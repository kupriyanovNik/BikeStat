//
//  PlanningView.swift
//

import SwiftUI

struct PlanningView: View {

    // MARK: - Property Wrappers

    @ObservedObject var planningViewModel: PlanningViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var coreDataManager: CoreDataManager

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            headerView()

            TextField(
                "Введите название поездки:",
                text: $planningViewModel.rideName
            )

            HStack {
                Text("Выберите время поездки:")

                Spacer()

                DatePicker(
                    "",
                    selection: $planningViewModel.rideTime,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
            }

            HStack {
                Text("Выберите дату поездки:")

                Spacer()

                DatePicker(
                    "",
                    selection: $planningViewModel.rideTime,
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
        }
        .padding()
        .foregroundStyle(.black)
        .font(.title2)
        .background {
            Pallete.accentColor
                .ignoresSafeArea()
        }
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
                    withAnimation {
                        homeViewModel.shouldShowRidePlanningView = false
                    }
                } label: {
                    Image(systemName: Images.back)
                        .font(.title2)
                        .bold()
                        .padding()
                }
            }
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
