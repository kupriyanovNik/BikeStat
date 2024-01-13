//
//  RideInfoView.swift
//

import SwiftUI

struct RideInfoView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @State private var currentIndex: Int = 0

    // MARK: - Internal Properties

    var ride: RideInfoModel

    // MARK: - Body

    var body: some View {
        ZStack {
            Color(hex: 0xB180C8)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                let rideDate = ride.rideDate ?? .now
                let rideDateString = rideDate.formatted(date: .abbreviated, time: .omitted)
                let rideDistance = String(format: "%.2f", Double(ride.distance) / 1000.0) + " км"
                let speedInfo = RideSpeedInfoModel(
                    avg: Int(ride.avgSpeed),
                    max: Int(ride.maxSpeed)
                )
                let pulseInfo = RidePulseInfoModel(
                    min: Int(ride.minPulse),
                    avg: Int(ride.avgPulse),
                    max: Int(ride.maxPulse)
                )
                let rideEstimatedComplexity = ride.estimatedComplexity ?? "no info"
                let rideRealComplexity = ride.realComplexity ?? "no info"

                Text("Поездка \(rideDateString)")
                    .font(.title)
                    .bold()
                    .hCenter()
                    .overlay {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: Images.back)
                                .rotationEffect(.degrees(-90))
                        }
                        .hLeading()
                        .padding(.horizontal)
                    }
                    .padding(.top)

                TabView(selection: $currentIndex) {
                    tabItemInfoView(
                        title: "Основная информация",
                        tag: 1,
                        texts: [
                            "Пройденное расстояние: \(rideDistance)"
                        ]
                    )

                    tabItemInfoView(
                        title: "Информация о скорости",
                        tag: 2,
                        texts: [
                            "Средняя Скорость: \(speedInfo.avg) км/ч",
                            "Максимальная скорость: \(speedInfo.max) км/ч"
                        ]
                    )

                    tabItemInfoView(
                        title: "Информация о пульсе",
                        tag: 3,
                        texts: [
                            "Минимальный пульс: \(pulseInfo.min) уд/мин",
                            "Средний пульс: \(pulseInfo.avg) уд/мин",
                            "Маскимальный пульс: \(pulseInfo.max) уд/мин"
                        ]
                    )

                    tabItemInfoView(
                        title: "Сложность",
                        tag: 4,
                        texts: [
                            "Расчетная сложность: \(rideEstimatedComplexity)",
                            "Реальная сложность: \(rideRealComplexity)"
                        ]
                    )
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
            .font(.title3)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .foregroundStyle(.white)
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func tabItemInfoView(
        title: String,
        tag: Int,
        texts: [String]
    ) -> some View {
        VStack {
            Text(title)
                .font(.title)
                .bold()
                .padding(.bottom)

            ForEach(texts, id: \.self) {
                Text($0)
            }
        }
        .font(.title2)
        .tag(tag)
    }
}
