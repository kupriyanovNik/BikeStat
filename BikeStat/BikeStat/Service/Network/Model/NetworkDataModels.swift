//
//  NetworkDataModels.swift
//

import Foundation

struct NetworkWatchDataModel: Codable {
    let code: Int
    let data: NetworkPulseDataModel
    let status: String
}

struct NetworkPulseDataModel: Codable {
    let pulse: NetworkPulseModel
}

struct NetworkPulseModel: Codable {
    let min, max, avg: Int
}
