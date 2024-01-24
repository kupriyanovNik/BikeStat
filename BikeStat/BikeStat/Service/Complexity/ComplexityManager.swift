//
//  ComplexityManager.swift
//

import Foundation
import SwiftUI

class ComplexityManager {

    // MARK: - Static Properties

    static let shared = ComplexityManager()

    // MARK: - Inits

    private init() { }

    // MARK: - Internal Functions

    func getEstimatedComplexity(
        estimatedDistance: Int,
        estimatedTime: Int
    ) -> RideComplexity {
        let avgSpeed = estimatedDistance / estimatedTime

        switch avgSpeed {
        case 0...5: return .easy
        case 6...15: return .medium
        case 16...: return .hard
        default: return .unowned
        }
    }

    func getRealComplexity(
        pulse: RidePulseInfoModel
    ) -> RideComplexity {
        let avgPulse = pulse.avg

        switch avgPulse {
        case 0...130: return .easy
        case 131...170: return .medium
        case 171...: return .hard
        default: return .unowned
        }
    }

    func getRealComplexity(
        avgPulse: Int
    ) -> RideComplexity {
        switch avgPulse {
        case 0...130: return .easy
        case 131...170: return .medium
        case 171...: return .hard
        default: return .unowned
        }
    }

    func getColorByComplexity(complexity: String?) -> Color {
        switch complexity {
        case "Простой": Pallete.Complexity.easy
        case "Средний": Pallete.Complexity.medium
        case "Сложный": Pallete.Complexity.hard
        default: Pallete.accentColor
        }
    }

    func getColorByEstimatedComplexity(complexity: String?) -> Color {
        switch complexity {
        case "Простой": Pallete.EstimatedComplexity.easy
        case "Средний": Pallete.EstimatedComplexity.medium
        case "Сложный": Pallete.EstimatedComplexity.hard
        default: Pallete.accentColor
        }
    }
}
