//
//  StatisticsChartData.swift
//

import Foundation

struct StatisticsChartDataModel: Identifiable, Equatable {
    let id = UUID()
    var number: Int
    var title: String
    var distance: Int
    var complexity: String?
}

struct RecomendationsChartDataModel: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var count: Int
    var complexity: String
}
