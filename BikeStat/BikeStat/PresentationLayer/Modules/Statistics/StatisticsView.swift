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

    private var last5Rides: [RideInfoModel] {
        coreDataManager.endedRides.suffix(5)
    }

    private var shouldShowStatistics: Bool {
        !coreDataManager.endedRides.isEmpty
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
            .chartLegend(.visible)
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
