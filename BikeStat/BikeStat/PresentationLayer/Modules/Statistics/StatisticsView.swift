//
//  StatisticsView.swift
//

import SwiftUI
import Charts

struct StatisticsView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var coreDataManager: CoreDataManager

    @State private var chartData: [StatisticsChartDataModel] = []

    // MARK: - Private Properties

    private var last5Rides: [RideInfoModel] {
        coreDataManager.endedRides.suffix(5)
    }

    private var shouldShowRecomendations: Bool {
        last5Rides.count > 5
    }

    private var middleDistance: Double {
        if last5Rides.count != 0 {
            return last5Rides.map {
                Double($0.realDistance)
            }.reduce(0, +) / Double(last5Rides.count)
        }

        return 0
    }

    private var middleDistanceAnnotation: String {
        let roundedMiddleDistance = round (
            round(
               100 * (middleDistance)
           ) / 1000
        ) / 100

        return "\(roundedMiddleDistance)"
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
            getLast5Rides()
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
            Chart {
                ForEach(chartData) { dataPoint in
                    BarMark(
                        x: .value("Номер", "\(dataPoint.number)"),
                        y: .value("Расстояние", dataPoint.distance/1000)
                    )
                    .foregroundStyle(
                        ComplexityManager.shared
                            .getColorByComplexity(
                                complexity: dataPoint.complexity
                            )
                            .gradient
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

            Text("График километража за последние 5 поездок ")
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }

    @ViewBuilder func recomendationsView() -> some View {
        VStack {
            Text("Рекомендиции по поездкам")
                .fontWeight(.semibold)
                .font(.title2)
        }
    }

    // MARK: - Private Functions

    private func getLast5Rides() {
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

        self.chartData = data
    }
}

// MARK: - Preview

#Preview {
    StatisticsView(
        coreDataManager: .init()
    )
}
