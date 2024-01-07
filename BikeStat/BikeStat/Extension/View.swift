//
//  View.swift
//

import SwiftUI

extension View {
    /// function that aligns View to leading corner
    func hLeading() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
    }

    /// function that aligns View to trailing corner
    func hTrailing() -> some View {
        frame(maxWidth: .infinity, alignment: .trailing)
    }

    /// function that aligns View to center
    func hCenter() -> some View {
        frame(maxWidth: .infinity, alignment: .center)
    }

    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        return safeArea
    }
}

extension View {
    /// a function that removes focus from the current TextField when user tapped
    func onTapEndEditing() -> some View {
        onTapGesture {
            hideKeyboard()
        }
    }

    /// function that leaves focus on the current TextField when user tapped
    func onTapContinueEditing() -> some View {
        onTapGesture { }
    }
}
