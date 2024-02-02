//
//  ComplexityManager.swift
//

import Foundation
import SwiftUI

final class ComplexityManager {

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
        pulse: RidePulseInfoModel,
        speed: RideSpeedInfoModel
    ) -> RideComplexity {
        prepareRealComplexity(for: pulse.avg, with: speed.avg)
    }

    func getRealComplexity(
        avgPulse: Int,
        avgSpeed: Int
    ) -> RideComplexity {
        prepareRealComplexity(for: avgPulse, with: avgSpeed)
    }

    func getColorByComplexity(complexity: String?) -> Color {
        switch complexity {
        case RideComplexity.easy.rawValue: Pallete.Complexity.easy
        case RideComplexity.medium.rawValue: Pallete.Complexity.medium
        case RideComplexity.hard.rawValue: Pallete.Complexity.hard
        default: Pallete.accentColor
        }
    }

    func getColorByEstimatedComplexity(complexity: String?) -> Color {
        switch complexity {
        case RideComplexity.easy.rawValue: Pallete.EstimatedComplexity.easy
        case RideComplexity.medium.rawValue: Pallete.EstimatedComplexity.medium
        case RideComplexity.hard.rawValue: Pallete.EstimatedComplexity.hard
        default: Pallete.accentColor
        }
    }

    // MARK: - Private Functions

    private func prepareRealComplexity(for pulse: Int, with speed: Int) -> RideComplexity {
        switch pulse * Int(Double(speed) / 2.8) {
        case 0...850: .easy
        case 851...1500: .medium
        case 1501...: .hard
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
