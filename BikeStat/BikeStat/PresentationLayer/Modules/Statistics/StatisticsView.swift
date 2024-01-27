//
//  StatisticsView.swift
//

import SwiftUI
import Charts

struct StatisticsView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var coreDataManager: CoreDataManager

    @State private var last5RidesChartData: [StatisticsChartDataModel] = []
    @State private var recomendationsChartData: [RecomendationsChartDataModel] = []

    @State private var showRecomendations: Bool = false

    // MARK: - Private Properties

    private var last5Rides: [RideInfoModel] {
        coreDataManager.endedRides.suffix(5)
    }

    private var shouldShowRecomendations: Bool {
        last5Rides.count >= 5
    }

    private var middleDistance: Double {
        if last5Rides.count != 0 {
            return last5Rides.map {
                Double($0.realDistance)
            }.reduce(0, +) / Double(last5Rides.count)
        }

        return 0
    }

    private var recommeddedComplexity: RideComplexity {
        if !last5Rides.isEmpty {
            let easyCount = getCountOfComplexity(for: .easy)
            let mediumCount = getCountOfComplexity(for: .medium)
            let hardCount = getCountOfComplexity(for: .hard)

            let maxCount = [easyCount, mediumCount, hardCount].max() ?? 0

            let majorComplexity: RideComplexity = easyCount == maxCount ? .easy : mediumCount == maxCount ? .medium : .hard

            if maxCount == last5Rides.count {
                return maxCount == easyCount ? .easy : maxCount == mediumCount ? .medium : .hard
            } else {
                switch majorComplexity {
                case .easy:
                    return .medium
                case .medium:
                    return .hard
                case .hard:
                    return .hard
                case .unowned:
                    return .unowned
                }
            }
        }

        return .unowned
    }

    private var middleDistanceAnnotation: String {
        "\(round(round(100 * (middleDistance)) / 1000) / 100)"
    }

    // MARK: - Body

    var body: some View {
        VStack {
            chartView()

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top, content: headerView)
        .overlay {
            if showRecomendations {
                Color.black
                    .opacity(0.15)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showRecomendations = false
                        }
                    }
            }
        }
        .overlay(alignment: .bottom) {
            if shouldShowRecomendations {
                bottomView()
            }
        }
        .onAppear {
            getLast5RidesChartData()
            getRecomendationsChartData()
        }
    }

    // MARK: - View Builders

    @ViewBuilder func headerView() -> some View {
        Text(Localizable.Statistics.pageTitle)
            .makeHeader {
                dismiss()
            }
    }

    @ViewBuilder func bottomView() -> some View {
        VStack {
            if showRecomendations {
                recomendationsView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            if !showRecomendations {
                Text("Нажмите, чтобы посмотреть рекомендации")
                    .multilineTextAlignment(.center)
            }
        }
        .font(.headline)
        .bold()
        .multilineTextAlignment(.center)
        .hCenter()
        .padding(24)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .white, radius: 100, x: 0, y: 100)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 5)
        .onTapGesture {
            withAnimation {
                withAnimation {
                    showRecomendations.toggle()
                }
            }
        }
        .ignoresSafeArea()
    }

    @ViewBuilder func chartView() -> some View {
        VStack {
            Chart {
                ForEach(last5RidesChartData) { dataPoint in
                    BarMark(
                        x: .value("Номер", "\(dataPoint.number)"),
                        y: .value("Расстояние", dataPoint.distance / 1000.0)
                    )
                    .foregroundStyle(
                        ComplexityManager.shared
                            .getColorByComplexity(
                                complexity: dataPoint.complexity
                            )
                    )
                }

                RuleMark(
                    y: .value("Среднее", middleDistance / 1000.0)
                )
                .foregroundStyle(.gray.gradient)
                .annotation(
                    position: .bottom,
                    alignment: .bottomLeading
                ) {
                    Text("Среднее: \(middleDistanceAnnotation) км")
                        .font(.headline)
                        .foregroundStyle(.gray.gradient)
                        .padding(.leading, 5)
                }
            }
            .frame(height: 300)
            .aspectRatio(1, contentMode: .fit)

            Text(Localizable.Statistics.chart)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }

    @ViewBuilder func recomendationsView() -> some View {
        VStack {
            Text(Localizable.Statistics.recomendations)
                .fontWeight(.semibold)
                .font(.title2)

            if #available(iOS 17, *) {
                Chart(recomendationsChartData, id: \.id) { item in
                    SectorMark(
                        angle: .value("key", item.count),
                        innerRadius: .ratio(0.5),
                        angularInset: 5
                    )
                    .cornerRadius(15)
                    .foregroundStyle(
                        ComplexityManager.shared
                            .getColorByComplexity(
                                complexity: item.complexity
                            )
                    )
                }
                .frame(width: 220, height: 220)
                .aspectRatio(1, contentMode: .fit)
                .chartLegend(position: .bottom, spacing: 20)
                .padding(.vertical, 10)
                .padding(.horizontal, 35)
                .background {
                    Pallete.accentColor
                        .cornerRadius(5)
                }
            }

            (
                Text(Localizable.Statistics.recomendedComplexity)
                +
                Text(recommeddedComplexity.rawValue)
                    .bold()
                    .foregroundColor(Pallete.accentColorForMap)
            )
            .multilineTextAlignment(.center)
        }
    }

    // MARK: - Private Functions

    private func getLast5RidesChartData() {
        var data: [StatisticsChartDataModel] = []
        var currentNumber: Int = 1

        for ride in last5Rides {
            data.append(
                .init(
                    number: currentNumber,
                    title: (ride.rideDate ?? .now).formatted(date: .abbreviated, time: .omitted),
                    distance: Double(ride.realDistance),
                    complexity: ride.realComplexity
                )
            )

            currentNumber += 1
        }

        self.last5RidesChartData = data
    }

    private func getRecomendationsChartData() {
        self.recomendationsChartData.append(
            .init(title: "Простые",
                  count: getCountOfComplexity(for: .easy),
                  complexity: RideComplexity.easy.rawValue)
        )
        self.recomendationsChartData.append(
            .init(title: "Средние",
                  count: getCountOfComplexity(for: .medium),
                  complexity: RideComplexity.medium.rawValue)
        )
        self.recomendationsChartData.append(
            .init(title: "Сложные",
                  count: getCountOfComplexity(for: .hard),
                  complexity: RideComplexity.hard.rawValue)
        )
    }

    private func getCountOfComplexity(for complexity: RideComplexity) -> Int {
        var counter: Int = 0

        for item in last5Rides {
            if item.realComplexity == complexity.rawValue {
                counter += 1
            }
        }

        return counter
    }
}

// MARK: - Preview

#Preview {
    StatisticsView(
        coreDataManager: .init()
    )
}
