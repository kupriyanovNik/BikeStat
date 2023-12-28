//
//  Internal+Ext.swift
//  BikeStat
//
//  Created by Никита Куприянов on 28.12.2023.
//

import SwiftUI
import Foundation

func delay(
    _ time: Double,
    execute: @escaping () -> ()
) {
    DispatchQueue.main.asyncAfter(
        wallDeadline: .now() + time,
        execute: execute
    )
}

func hideKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
    )
}
