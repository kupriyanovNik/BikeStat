//
//  Date.swift
//

import Foundation

extension Date {
    /// unused
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

    func makeDateComponents() -> DateComponents {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: self)
        let hour = calendar.component(.hour, from: self)
        let day = calendar.component(.day, from: self)

        var dateComp = DateComponents()
        dateComp.hour = hour
        dateComp.minute = minute
        dateComp.day = day

        return dateComp
    }
}
