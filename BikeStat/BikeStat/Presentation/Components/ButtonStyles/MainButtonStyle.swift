//
//  MainButtonStyle.swift
//  BikeStat
//
//  Created by Никита Куприянов on 28.12.2023.
//

import SwiftUI

struct HeaderButtonStyle: ButtonStyle {

    var pressedScale: Double = 1.1
    var pressedOpacity: Double = 0.85

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1)
            .opacity(configuration.isPressed ? pressedOpacity : 1)
            .animation(.spring, value: configuration.isPressed)
    }
}
