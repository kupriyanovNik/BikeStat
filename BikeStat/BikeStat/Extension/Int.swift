//
//  Int.swift
//

import Foundation

extension Int {
    func formatAsTime() -> String {
        let intFormats = Strings.NumberFormats.self
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let remainingSeconds = self % 60

        let formattedHours = String(format: intFormats.forTime, hours)
        let formattedMinutes = String(format: intFormats.forTime, minutes)
        let formattedSeconds = String(format: intFormats.forTime, remainingSeconds)

        let shouldShowHours = formattedHours != "00"

        let hoursText = shouldShowHours ? "\(formattedHours):" : ""

        return "\(hoursText)\(formattedMinutes):\(formattedSeconds)"
    }

}
