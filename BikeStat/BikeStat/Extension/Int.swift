//
//  Int.swift
//

import Foundation

extension Int {
    func formatAsTime() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let remainingSeconds = self % 60

        let formattedHours = String(format: .partOfTimeFormat, hours)
        let formattedMinutes = String(format: .partOfTimeFormat, minutes)
        let formattedSeconds = String(format: .partOfTimeFormat, remainingSeconds)

        let shouldShowHours = formattedHours != "00"

        let hoursText = shouldShowHours ? "\(formattedHours):" : ""

        return "\(hoursText)\(formattedMinutes):\(formattedSeconds)"
    }
}

extension Int? {
    func safeUnwrap(with value: Int = 0) -> Int {
        self ?? value
    }
}
