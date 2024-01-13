//
//  SettingsView.swift
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @Namespace var animation

    @ObservedObject var settingsViewModel: SettingsViewModel

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

    @ViewBuilder func metricPickerView() -> some View {
        VStack(alignment: .leading) {
            Text("Единицы измерения:")
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
                .stroke(.black, lineWidth: 2)
                .frame(width: 30, height: 30)
                .overlay {
                    if isSelected {
                        Circle()
                            .fill(Color(hex: 0xB180C8))
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
        settingsViewModel: .init()
    )
}
