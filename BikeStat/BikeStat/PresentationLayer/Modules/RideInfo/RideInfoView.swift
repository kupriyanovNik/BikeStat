//
//  RideInfoView.swift
//

import SwiftUI

struct RideInfoView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @State private var currentIndex: Int = 0

    // MARK: - Internal Properties

//    var ride: RideInfoModel

    // MARK: - Body

    var body: some View {
        ZStack {
            Color(hex: 0xB180C8)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Text("Поездка (дата)")
                    .font(.title)
                    .bold()
                    .hCenter()
                    .overlay {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: Images.back)
                                .rotationEffect(.degrees(-90))
                        }
                        .hLeading()
                        .padding(.horizontal)
                    }
                    .padding(.top)

                TabView(selection: $currentIndex) {
                    tabItemInfoView(
                        title: "Основная информация",
                        tag: 1,
                        texts: [
                            "Пройденное расстояние: 2км",
                            "Время в пути: 5 минут"
                        ]
                    )

                    tabItemInfoView(
                        title: "Информация о скорости",
                        tag: 2,
                        texts: [
                            "Средняя Скорость: 20 км/ч",
                            "Максимальная скорость: 33 км/ч"
                        ]
                    )

                    tabItemInfoView(
                        title: "Информация о пульсе",
                        tag: 3,
                        texts: [
                            "Минимальный пульс: 125 уд/мин",
                            "Средний пульс: 150 уд/мин",
                            "Маскимальный пульс: 200 уд/мин"
                        ]
                    )

                    tabItemInfoView(
                        title: "Сложность",
                        tag: 4,
                        texts: [
                            "Расчетная сложность: сложный",
                            "Реальная сложность: средний"
                        ]
                    )
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
            .font(.title3)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .foregroundStyle(.white)
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func tabItemInfoView(
        title: String,
        tag: Int,
        texts: [String]
    ) -> some View {
        VStack {
            Text(title)
                .font(.title)
                .bold()
                .padding(.bottom)

            ForEach(texts, id: \.self) {
                Text($0)
            }
        }
        .font(.title2)
        .tag(tag)
    }
}

// MARK: - Preview

#Preview {
    RideInfoView()
}
