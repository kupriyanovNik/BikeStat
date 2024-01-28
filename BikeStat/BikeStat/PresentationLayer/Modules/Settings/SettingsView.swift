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

    @State private var isExpandedUnitsPicker: Bool = false
    @State private var isExpandedThemePicker: Bool = false

    // MARK: - Private Properties

    private let localizable = Localizable.SettingsView.self

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                metricPickerView()
                    .hLeading()

                themePickerView()
                    .hLeading()
            }
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
            HStack {
                Text("Единицы измерения")

                Image(systemName: Images.back)
                    .rotationEffect(.degrees(isExpandedUnitsPicker ? 270 : 180))
            }
            .bold()
            .font(.title2)
            .padding(.leading)
            .onTapGesture {
                withAnimation {
                    isExpandedUnitsPicker.toggle()
                }
            }

            Group {
                if isExpandedUnitsPicker {
                    metricPickerViewCell(value: true)

                    metricPickerViewCell(value: false)
                }
            }
            .padding(.leading)
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
                .font(.headline)

            Spacer()
        }
        .padding(.leading, 2)
        .onTapGesture {
            withAnimation(.smooth(extraBounce: 0.4)) {
                settingsViewModel.isMetricUnits = value
            }
        }
    }

    @ViewBuilder func themePickerView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Цветовая гамма")

                Image(systemName: Images.back)
                    .rotationEffect(.degrees(isExpandedThemePicker ? 270 : 180))
            }
            .bold()
            .font(.title2)
            .padding(.leading)
            .onTapGesture {
                withAnimation {
                    isExpandedThemePicker.toggle()
                }
            }

            if isExpandedThemePicker {
                themesListView()
            }
        }
    }

    @ViewBuilder func themesListView() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: -10) {
                ForEach(0..<DataSource.themesCount) { themeIndex in
                    let theme = DataSource.getTheme(themeIndex: themeIndex)
                    let isSelected = theme.accentColor == themeManager.selectedTheme.accentColor

                    ThemePickerCell(
                        theme: theme,
                        isSelected: isSelected
                    ) {
                        withAnimation {
                            themeManager.selectedThemeIndex = themeIndex
                        }
                    }
                    .padding()
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Preview

#Preview {
    SettingsView(
        settingsViewModel: .init(),
        themeManager: .init()
    )
}
