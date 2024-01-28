//
//  SettingsView.swift
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @Namespace var animation

    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var themeManager: ThemeManager

    // MARK: - Private Properties

    private let localizable = Localizable.SettingsView.self

    // MARK: - Body

    var body: some View {
        ScrollView {
            metricPickerView()
                .padding(.horizontal, 14)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top, content: headerView)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }

    // MARK: - ViewBuilders

    @ViewBuilder func headerView() -> some View {
        Text(localizable.pageTitle)
            .makeHeader {
                dismiss()
            }
    }

    @ViewBuilder func metricPickerView() -> some View {
        VStack(alignment: .leading) {
            Text(localizable.units)
                .bold()
                .font(.title2)
                .padding(.leading, 2)

            metricPickerViewCell(value: true)

            metricPickerViewCell(value: false)
        }
    }

    @ViewBuilder func metricPickerViewCell(value: Bool) -> some View {
        let isSelected = settingsViewModel.isMetricUnits == value
        let text = value ? "км, км/ч" : "мили, мили/ч"

        HStack {
            Circle()
                .stroke(Pallete.textColor, lineWidth: 2)
                .frame(width: 30, height: 30)
                .overlay {
                    if isSelected {
                        Circle()
                            .fill(Pallete.accentColor)
                            .padding(2)
                            .matchedGeometryEffect(id: "selectedUnits", in: animation)
                    }
                }
                .scaleEffect(isSelected ? 1.1 : 1)

            Text(text)
                .bold()
                .font(.title2)

            Spacer()
        }
        .padding(.leading, 2)
        .onTapGesture {
            withAnimation(.smooth(extraBounce: 0.4)) {
                settingsViewModel.isMetricUnits = value
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView(
        settingsViewModel: .init(),
        themeManager: .init()
    )
}
