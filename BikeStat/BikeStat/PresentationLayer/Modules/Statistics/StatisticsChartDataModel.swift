//
//  StatisticsChartData.swift
//

import Foundation

struct StatisticsChartDataModel: Identifiable, Equatable {
    let id = UUID()
    var number: Int
    var title: String
    var distance: Double
    var complexity: String?
}

struct RecommendationsChartDataModel: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var count: Int
    var complexity: String
}

struct StatisticsModel {
    static let easyRecommendations = [String]()

    static let mediumRecommendations = [String]()

    static let hardRecommendations = [String]()
}
