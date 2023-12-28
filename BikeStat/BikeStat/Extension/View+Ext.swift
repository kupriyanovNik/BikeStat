//
//  View+Ext.swift
//  BikeStat
//
//  Created by Никита Куприянов on 28.12.2023.
//

import SwiftUI

extension View {
    func hLeading() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
    }

    func hTrailing() -> some View {
        frame(maxWidth: .infinity, alignment: .trailing)
    }

    func hCenter() -> some View {
        frame(maxWidth: .infinity, alignment: .center)
    }

    /// unused
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        return safeArea
    }
}

extension View {
    func onTapEndEditing() -> some View {
        onTapGesture {
            hideKeyboard()
        }
    }

    func onTapContinueEditing() -> some View {
        onTapGesture { }
    }
}
