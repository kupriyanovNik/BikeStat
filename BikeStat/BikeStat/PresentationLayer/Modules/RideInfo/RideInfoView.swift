//
//  RideInfoView.swift
//

import SwiftUI

struct RideInfoView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

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

                VStack {
                    Text("Пройденное расстояние: 2км")

                    Text("Время в пути: 5 минут")

                    Text("Средняя Скорость: 20 км/ч")

                    Text("Максимальная скорость: 33 км/ч")

                    Text("Минимальный пульс: 125 уд/мин")

                    Text("Средний пульс: 150 уд/мин")

                    Text("Маскимальный пульс: 200 уд/мин")

                    Text("Расчетная сложность: сложный")

                    Text("Реальная сложность: средний")
                }
            }
            .font(.title3)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
        .foregroundStyle(.white)
        }
    }
}

// MARK: - Preview

#Preview {
    RideInfoView()
}
