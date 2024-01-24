//
//  StatisticsChartData.swift
//

import Foundation

struct StatisticsChartData: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var distance: Int
    var complexity: String?
}
