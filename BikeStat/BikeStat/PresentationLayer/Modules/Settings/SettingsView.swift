//
//  SettingsView.swift
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    // MARK: - Body

    var body: some View {
        ScrollView {
            
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top, content: headerView)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }

    // MARK: - ViewBuilders

    @ViewBuilder func headerView() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: Images.back)
                    .font(.title2)
                    .bold()
            }

            Spacer()

            Text("Настройки")
                .font(.largeTitle)
                .bold()

            Spacer()
        }
        .foregroundStyle(.black)
        .padding([.horizontal, .top])
        .offset(y: -16)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
}
