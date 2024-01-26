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
        ScrollView {
            chartView()

            if shouldShowRecomendations {
                recomendationsView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top, content: headerView)
        .onAppear {
            getLast5RidesChartData()
            getRecomendationsChartData()
        }
    }

    // MARK: - View Builders

    @ViewBuilder func headerView() -> some View {
        Text("Статистика")
            .makeHeader {
                dismiss()
            }
    }

    @ViewBuilder func chartView() -> some View {
        VStack {
            Text("График километража за последние 5 поездок")
                .font(.caption)
                .multilineTextAlignment(.center)

            Chart {
                ForEach(last5RidesChartData) { dataPoint in
                    BarMark(
                        x: .value("Номер", "\(dataPoint.number)"),
                        y: .value("Расстояние", (dataPoint.distance)/1000)
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
        }
        .padding(.horizontal)
    }

    @ViewBuilder func recomendationsView() -> some View {
        VStack {
            Text("Рекомендиции по поездкам")
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
                Text("Рекомендованная сложность следующего маршрута: ")
                +
                Text(recommeddedComplexity.rawValue)
                    .bold()
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
                    distance: Int(ride.realDistance),
                    complexity: ride.realComplexity
                )
            )
            currentNumber += 1
        }

        self.last5RidesChartData = data
    }

    private func getRecomendationsChartData() {
        self.recomendationsChartData.append(
            .init(title: "Простые", count: getCountOfComplexity(for: .easy), complexity: "Простой")
        )
        self.recomendationsChartData.append(
            .init(title: "Средние", count: getCountOfComplexity(for: .medium), complexity: "Средний")
        )
        self.recomendationsChartData.append(
            .init(title: "Сложные", count: getCountOfComplexity(for: .hard), complexity: "Сложный")
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
