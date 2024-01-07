//
//  Internal.swift
//

import SwiftUI
import Foundation

/// a function that executes code asynchronously after a specified delay
func delay(
    _ time: Double,
    execute: @escaping () -> ()
) {
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + time, execute: execute)
}

/// a function that removes focus from the current TextField
func hideKeyboard() {
    UIApplication.shared
        .sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
}
