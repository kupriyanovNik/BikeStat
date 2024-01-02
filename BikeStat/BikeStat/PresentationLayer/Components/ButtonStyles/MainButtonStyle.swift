//
//  MainButtonStyle.swift
//


import SwiftUI

struct MainButtonStyle: ButtonStyle {

    // MARK: - Internal Properties

    var pressedScale: Double = 1.1
    var pressedOpacity: Double = 1
    var anchor: UnitPoint = .center

    // MARK: - Body

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1, anchor: anchor)
            .opacity(configuration.isPressed ? pressedOpacity : 1)
            .animation(.spring, value: configuration.isPressed)
    }
}
