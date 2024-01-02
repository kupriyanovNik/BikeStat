//
//  Date.swift
//

import Foundation

extension Date {
    /// Function returning a localized string depending on the current time
    func greeting() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)

        if hour >= 0 && hour < 6 {
            return "Доброй ночи!"
        } else if hour >= 6 && hour < 12 {
            return "Доброе утро!"
        } else if hour >= 12 && hour < 18 {
            return "Добрый день!"
        } else {
            return "Добрый вечер!"
        }
    }
}
