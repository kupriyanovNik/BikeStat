//
//  MainButtonStyle.swift
//


import SwiftUI

struct MainButtonStyle: ButtonStyle {

    // MARK: - Internal Properties

    var pressedScale: Double = 1.1
    var pressedOpacity: Double = 1
    var scaleAnchor: UnitPoint = .center

    // MARK: - Body

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        
        configuration.label
            .scaleEffect(isPressed ? pressedScale : 1, anchor: scaleAnchor)
            .opacity(isPressed ? pressedOpacity : 1)
            .animation(.spring, value: isPressed)
    }
}
