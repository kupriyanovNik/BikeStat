//
//  RadioButton.swift
//

import SwiftUI

struct RadioButton: View {

    // MARK: - Property Wrappers

    @Binding var isSelected: Bool

    // MARK: - Internal Properties

    var accentColor: Color
    var animation: Animation = .default
    var withImpact: Bool = true

    // MARK: - Body

    var body: some View {
        ZStack {
            Circle()
                .stroke(accentColor, style: .init(lineWidth: 2))

            if isSelected {
                Circle()
                    .fill(accentColor)
                    .padding(2)
                    .overlay {
                        Image(systemName: Images.checkmark)
                            .foregroundColor(.white)
                    }
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .onTapGesture {
            if withImpact {
                ImpactManager.shared.generateFeedback(style: .medium)
            }

            isSelected.toggle()
        }
        .animation(animation, value: isSelected)
    }
}

// MARK: - Preview

#Preview {
    RadioButton(
        isSelected: .constant(true),
        accentColor: .purple
    )
    .frame(width: 30, height: 30)
}
