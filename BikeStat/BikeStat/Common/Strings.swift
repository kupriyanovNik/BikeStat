//
//  Strings.swift
//

import Foundation

enum Strings {
    enum Network {
        static let apiUrl = "https://dt.miet.ru/ppo_it/api/watch"
        static let headerFields = ["x-access-tokens": "az4fvf7nzi1XPIsYiMEu"]
    }

    enum Time {
        static let withHours = "%02i:%02i:%02i"
        static let withoutHours = "%02i:%02i"
    }

    enum NumberFormats {
        static let forTime = "%02d"
        static let forDistance = "%.2f"
        static let forDistanceShort = "%.1f"
    }
}
