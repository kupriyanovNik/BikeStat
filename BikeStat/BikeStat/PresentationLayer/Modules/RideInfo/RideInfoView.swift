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

    var deleteAction: (() -> ())? = nil

    // MARK: - Private Properties

    private let localizable = Localizable.RideInfoView.self

    private var pageTitle: String {
        if let title = ride.title, title != "" {
            return title
        }

        let rideDate = ride.rideDate ?? .now
        let rideDateString = rideDate.formatted(date: .abbreviated, time: .omitted)
        return rideDateString
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Pallete.accentColor
                .ignoresSafeArea()

            VStack(spacing: 25) {
                let rideDate = ride.rideDate ?? .now
                let rideDateString = rideDate.formatted(date: .abbreviated, time: .omitted)
                let rideDistance = String(
                    format: Strings.NumberFormats.forDistance,
                    Double(ride.realDistance) / 1000.0
                ) + " км"
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

                let avgSpeedKMPH = round(
                    100 * (3.6 * Double(speedInfo.avg))
                ) / 100
                let maxSpeedKMPH = round(
                    100 * (3.6 * Double(speedInfo.max))
                ) / 100

                headerView()

                TabView(selection: $currentIndex) {
                    tabItemInfoView(
                        title: localizable.mainInformation,
                        tag: 1,
                        texts: [
                            "\(localizable.distance): \(rideDistance)"
                        ]
                    )

                    tabItemInfoView(
                        title: localizable.speedInfo,
                        tag: 2,
                        texts: [
                            "\(localizable.avgSpeed): \(avgSpeedKMPH) км/ч",
                            "\(localizable.maxSpeed): \(maxSpeedKMPH) км/ч"
                        ]
                    )

                    tabItemInfoView(
                        title: localizable.pulseInfo,
                        tag: 3,
                        texts: [
                            "\(localizable.minPulse): \(pulseInfo.min) уд/мин",
                            "\(localizable.avgPulse): \(pulseInfo.avg) уд/мин",
                            "\(localizable.maxPulse): \(pulseInfo.max) уд/мин"
                        ]
                    )

                    tabItemInfoView(
                        title: localizable.complexity,
                        tag: 4,
                        texts: [
                            "\(localizable.estimatedComplexity): \(rideEstimatedComplexity)",
                            "\(localizable.realComplexity): \(rideRealComplexity)"
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

    @ViewBuilder func headerView() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: Images.back)
                    .rotationEffect(.degrees(-90))
            }

            Spacer()

            Text(pageTitle)
                .font(.title)
                .bold()

            Spacer()

            Button {
                dismiss()

                delay(0.5) {
                    deleteAction?()
                }
            } label: {
                Image(systemName: Images.trash)
            }
        }
        .padding([.horizontal, .top])
    }

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
