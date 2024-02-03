//
//  StatisticsView.swift
//

import SwiftUI
import Charts

struct StatisticsView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var themeManager: ThemeManager

    @State private var last10RidesChartData: [StatisticsChartDataModel] = []
    @State private var recomendationsChartData: [RecomendationsChartDataModel] = []

    @State private var showRecomendations: Bool = false

    // MARK: - Private Properties

    private var last10Rides: [RideInfoModel] {
        coreDataManager.endedRides.suffix(10)
    }

    private var shouldShowRecomendations: Bool {
        last10Rides.count >= 3
    }

    private var middleDistance: Double {
        if last10Rides.count != 0 {
            return last10Rides.map {
                Double($0.realDistance)
            }.reduce(0, +) / Double(last10Rides.count)
        }

        return 0
    }

    private var recommeddedComplexity: RideComplexity {
        if !last10Rides.isEmpty {
            let easyCount = getCountOfComplexity(for: .easy)
            let mediumCount = getCountOfComplexity(for: .medium)
            let hardCount = getCountOfComplexity(for: .hard)

            let maxCount = [easyCount, mediumCount, hardCount].max() ?? 0

            let majorComplexity: RideComplexity = easyCount == maxCount ? .easy : mediumCount == maxCount ? .medium : .hard

            if maxCount == last10Rides.count {
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
                    .opacity(colorScheme == .light ? 0.3 : 0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showRecomendations = false
                        }
                    }
            }
        }
        .overlay(alignment: .top) {
            topRecomendationsView()
        }
        .overlay(alignment: .bottom) {
            bottomRecomendationsView()
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

    @ViewBuilder func topRecomendationsView() -> some View {
        if showRecomendations {
            Text("sdfsdfhsdafga fsdhgihreiuhguehwrihguiweiurhgiuerhwguiher wuighw ieurhgiuheriuhgerwuhghwerhiuhuiehriugheiurhgh ewirghiuwer fdg fdk gdsgs dgfdgdfdgsfg i")
                .makeToast(colorScheme: colorScheme) {
                    withAnimation {
                        showRecomendations.toggle()
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
        }
    }

    @ViewBuilder func bottomRecomendationsView() -> some View {
        VStack {
            if showRecomendations {
                recomendationsView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                Text("Посмотреть рекомендации")
                    .multilineTextAlignment(.center)
            }
        }
        .makeToast(colorScheme: colorScheme) {
            withAnimation {
                showRecomendations.toggle()
            }
        }
    }

    @ViewBuilder func chartView() -> some View {
        VStack {
            Chart {
                ForEach(last10RidesChartData) { dataPoint in
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
                .foregroundStyle(.primary)

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
                    themeManager.selectedTheme.accentColor
                        .opacity(colorScheme == .dark ? 0.7 : 1)
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

        for ride in last10Rides {
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

        self.last10RidesChartData = data
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

        for item in last10Rides {
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
        coreDataManager: .init(),
        themeManager: .init()
    )
}
