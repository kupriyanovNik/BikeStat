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
    @State private var isExpandedWeightPicker: Bool = false
    @State private var isExpandedInternalSettingsView: Bool = false

    // MARK: - Private Properties

    private let localizable = Localizable.SettingsView.self

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                metricPickerView()
                    .hLeading()

                Divider()

                themePickerView()
                    .hLeading()

                Divider()

                weightPickerView()
                    .hLeading()

                Divider()

                internalSettingsView()
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

    @ViewBuilder func expandableRow(
        text: String,
        value: Bool,
        action: @escaping () -> ()
    ) -> some View {
        HStack {
            Text(text)

            Image(systemName: Images.back)
                .rotationEffect(.degrees(value ? 270 : 180))
        }
        .bold()
        .font(.title2)
        .padding(.leading)
        .onTapGesture {
            action()
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
                            .fill(themeManager.selectedTheme.accentColor)
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

    @ViewBuilder func metricPickerView() -> some View {
        VStack(alignment: .leading) {
            expandableRow(text: "Единицы измерения", value: isExpandedUnitsPicker) {
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

    @ViewBuilder func themesListView() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: -10) {
                ForEach(0..<ThemeDataSource.themesCount) { themeIndex in
                    let theme = ThemeDataSource.getTheme(themeIndex: themeIndex)
                    let isSelected = theme.accentColor == themeManager.selectedTheme.accentColor

                    ThemePickerCell(
                        theme: theme,
                        isSelected: isSelected
                    ) {
                        withAnimation {
                            themeManager.setThemeIndet(at: themeIndex)
                        }
                    }
                    .padding()
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder func themePickerView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            expandableRow(text: "Цветовая гамма", value: isExpandedThemePicker) {
                withAnimation {
                    isExpandedThemePicker.toggle()
                }
            }

            if isExpandedThemePicker {
                themesListView()
            }
        }
    }

    @ViewBuilder func weightPickerView() -> some View {
        expandableRow(text: "Персональная информация", value: isExpandedWeightPicker) {
            withAnimation {
                isExpandedWeightPicker.toggle()
            }
        }

        if isExpandedWeightPicker {
            weightPickerRow()
        }
    }

    @ViewBuilder func weightPickerRow() -> some View {
        HStack {
            Text("Ваш вес")
                .font(.headline)

            Spacer()

            Picker("", selection: $settingsViewModel.userWeight) {
                ForEach(15...150, id: \.self) {
                    Text("\($0) кг")
                        .id($0)
                        .tag($0)
                }
            }
            .tint(.black)
            .labelsHidden()
        }
        .padding(.horizontal)
    }

    @ViewBuilder func internalSettingsView() -> some View {
        expandableRow(text: "Основные настроки", value: isExpandedInternalSettingsView) {
            withAnimation {
                isExpandedInternalSettingsView.toggle()
            }
        }

        if isExpandedInternalSettingsView {
            internalSettingsRowView()
        }
    }

    @ViewBuilder func internalSettingsRowView() -> some View {
        HStack {
            Text("Автоматически завершать\nпоездку по истечению\nзапланированного времени")
                .font(.headline)
                .multilineTextAlignment(.leading)

            Spacer()

            RadioButton(
                isSelected: $settingsViewModel.shouldAutomaticlyEndRide,
                accentColor: themeManager.selectedTheme.accentColor
            )
            .frame(width: 30, height: 30)
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    SettingsView(
        settingsViewModel: .init(),
        themeManager: .init()
    )
}
