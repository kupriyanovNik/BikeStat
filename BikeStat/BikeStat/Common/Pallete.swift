//
//  Pallete.swift
//

import SwiftUI

enum Pallete {
    static let accentColor = Color(hex: 0x72A5D5)

    enum Complexity {
        static let easy = Color(hex: 0xAEDDA6)
        static let normal = Color(hex: 0xFFF2AF)
        static let hard = Color(hex: 0xFD9898)

        static func getRandomColor() -> Color {
            return [
                Complexity.easy, Complexity.normal, Complexity.hard
            ].randomElement() ?? .clear
        }
    }
}
