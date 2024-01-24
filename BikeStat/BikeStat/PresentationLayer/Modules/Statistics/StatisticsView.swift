//
//  StatisticsView.swift
//

import SwiftUI
import Charts

struct StatisticsView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var coreDataManager: CoreDataManager

    @State private var chartData: [StatisticsChartData] = []

    // MARK: - Private Properties

    private var last7Rides: [RideInfoModel] {
        coreDataManager.endedRides.suffix(7)
    }

    private var shouldShowStatistics: Bool {
        !coreDataManager.endedRides.isEmpty
    }

    private var shouldShowRecomendations: Bool {
        last7Rides.count > 7
    }

    private var middleDistance: Double {
        if last7Rides.count != 0 {
            return last7Rides.map {
                Double($0.realDistance)
            }.reduce(0, +) / Double(last7Rides.count)
        }

        return 0
    }

    private var middleDistanceAnnotation: String {
        let roundedMiddleDistance = round(
            10 * (middleDistance)
        ) / 10

        return "\(roundedMiddleDistance)"
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            Chart {
                ForEach(chartData) { dataPoint in
                    BarMark(
                        x: .value("День", dataPoint.title),
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
                .foregroundStyle(.black)
                .annotation(
                    position: .bottom,
                    alignment: .bottomLeading
                ) {
                    Text("Среднее: \(middleDistanceAnnotation) км")
                        .padding(.leading, 5)
                }
            }
            .padding(.horizontal)
            .frame(height: 300)
            .aspectRatio(1, contentMode: .fit)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top, content: headerView)
        .onAppear {
            var data: [StatisticsChartData] = []

            for ride in last7Rides {
                data.append(
                    .init(
                        title: (ride.rideDate ?? .now).formatted(date: .abbreviated, time: .omitted),
                        distance: Int(ride.realDistance),
                        complexity: ride.realComplexity
                    )
                )
            }

            self.chartData = data
        }
    }

    // MARK: - View Builders

    @ViewBuilder func headerView() -> some View {
        Text("Статистика")
            .makeHeader {
                dismiss()
            }
    }
}

// MARK: - Preview

#Preview {
    StatisticsView(
        coreDataManager: .init()
    )
}
