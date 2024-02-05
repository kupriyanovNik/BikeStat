//
//  TimeInterval.swift
//

import Foundation

extension TimeInterval {
    func asString() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60

        if hours != 0 {
            return String(
                format: .timeFormat,
                hours, minutes, seconds
            )
        }

        return String(
            format: .shortTimeFormat,
            minutes, seconds
        )
    }
}
