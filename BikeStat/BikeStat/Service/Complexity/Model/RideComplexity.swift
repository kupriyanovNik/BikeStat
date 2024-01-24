//
//  RideComplexity.swift
//

import SwiftUI

enum RideComplexity {
    case easy, medium, hard, `unowned`

    var rawValue: String {
        switch self {
        case .easy:
            "Простой"
        case .medium:
            "Средний"
        case .hard:
            "Сложный"
        case .unowned:
            "хз"
        }
    }

    var estimatedComplexityColor: Color {
        switch self {
        case .easy:
            Pallete.EstimatedComplexity.easy
        case .medium:
            Pallete.EstimatedComplexity.medium
        case .hard:
            Pallete.EstimatedComplexity.hard
        case .unowned:
            .clear
        }
    }

    var realComplexityColor: Color {
        switch self {
        case .easy:
            Pallete.Complexity.easy
        case .medium:
            Pallete.Complexity.medium
        case .hard:
            Pallete.Complexity.hard
        case .unowned:
            .clear
        }
    }
}
