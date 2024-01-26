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
        prepareEstimatedComplexity(for: estimatedDistance / estimatedTime)
    }

    func getRealComplexity(
        pulse: RidePulseInfoModel
    ) -> RideComplexity {
        prepareRealComplexity(for: pulse.avg)
    }

    func getRealComplexity(
        avgPulse: Int
    ) -> RideComplexity {
        prepareRealComplexity(for: avgPulse)
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

    // MARK: - Private Functions

    private func prepareRealComplexity(for pulse: Int) -> RideComplexity {
        switch pulse {
        case 0...120: .easy
        case 121...145: .medium
        case 146...: .hard
        default: .unowned
        }
    }

    private func prepareEstimatedComplexity(for speed: Int) -> RideComplexity {
        switch speed {
        case 0...3: return .easy
        case 4...10: return .medium
        case 11...: return .hard
        default: return .unowned
        }
    }
}
