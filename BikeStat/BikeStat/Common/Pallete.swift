//
//  Pallete.swift
//

import SwiftUI

enum Pallete {
    static let accentColor = Color(hex: 0x72A5D5)
    static let showHistoryColor = Color(hex: 0x406E9A)

    enum Complexity {
        static let easy = Color(hex: 0xAEDDA6)
        static let medium = Color(hex: 0xFFF2AF)
        static let hard = Color(hex: 0xFD9898)

        static func getRandomColor() -> Color {
            return [
                Complexity.easy, 
                Complexity.medium,
                Complexity.hard
            ].randomElement() ?? .clear
        }
    }

    enum EstimatedComplexity {
        static let easy = Color(hex: 0xDCFFD6)
        static let medium = Color(hex: 0xFFF6C9)
        static let hard = Color(hex: 0xFFC2C2)

        static func getRandomColor() -> Color {
            return [
                EstimatedComplexity.easy,
                EstimatedComplexity.medium,
                EstimatedComplexity.hard
            ].randomElement() ?? .clear
        }
    }
}
