//
//  StatisticsChartData.swift
//

import Foundation

struct StatisticsChartDataModel: Identifiable, Equatable {
    let id = UUID()
    var number: Int
    var title: String
    var distance: Double
    var complexity: String?
}

struct RecommendationsChartDataModel: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var count: Int
    var complexity: String
}

struct RecommendationTextModel {
    static let easyRecommendations = [
        "Начинайте с коротких поездок, чтобы ваш организм мог постепенно адаптироваться к физической активности.",
        "Пейте много воды, чтобы избежать обезвоживания.",
        "Следите за Вашим самочувствием. Если что-то болит, отдохните, иначе могут быть плохие последствия.",
        "Делайте качественную разминку перед тренировками."
    ]

    static let mediumRecommendations = [
        "Не забывайте следить за состоянием Вашего велосипеда и собственным здоровьем!",
        "Находите новых друзей и катайтесь вместе, это полезно и весело!",
        "Обязательно поучавствуйте в открытом велосипедном марафоне!",
        "Со временем увеличивайте скорость. Попробуйте [HIIT](https://www.championat.com/lifestyle/article-4150673-chto-takoe-hiit-trenirovki-pljusy-i-protivopokazanija-kompleks-uprazhnenij-dlja-doma-video.html)"
    ]

    static let hardRecommendations = [
        "Экспериментируйте с пройденным расстоянием, возможно, Вы можете больше, чем думаете.",
        "Работайте над техникой спуска и подъема на холмы, это крайне важно на Вашем уровне подготовки.",
        "Чаще учавствуте в соревнованиях!!",
        "Попробуйте методику [интервальных тренировок](https://my-fit.ru/fitness_guide/intervalnye-trenirovki---chto-eto-takoe-i-komu-podoidut/)"
    ]
}
