//
//  RideComplexity.swift
//

import Foundation

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
}
