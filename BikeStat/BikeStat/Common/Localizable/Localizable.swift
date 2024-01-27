//
//  Localizable.swift
//

import Foundation

enum Localizable {
    enum HomeView {
        static let pageTitle = "BikeStat"
        static let rideHistory = "История поездок"
        static let plannedRides = "Запланированные поездки:"
        static let planRide = "Планирование поездок"
        static let start = "Начать"
        static let goto = "Перейти"
        static let ride = "Поездка"
    }

    enum RideView {
        static let pageTitle = "Новая поездка"
        static let start = "Старт"
        static let finish = "Финиш"
        static let speed = "Скорость"
        static let distance = "Путь"
    }

    enum SettingsView {
        static let pageTitle = "Настройки"
        static let units = "Единицы измерения:"
    }

    enum RideInfoView {
        static let ride = "Поездка"
        static let mainInformation = "Основная информация"
        static let timeDuringRide = "Время в пути"
        static let calories = "Калории"
        static let distance = "Расстояние"
        static let speedInfo = "Информация о скорости"
        static let avgSpeed = "Средняя Скорость"
        static let maxSpeed = "Максимальная скорость"
        static let pulseInfo = "Информация о пульсе"
        static let minPulse = "Минимальный пульс"
        static let avgPulse = "Средний пульс"
        static let maxPulse = "Максимальный пульс"
        static let complexity = "Сложность"
        static let estimatedComplexity = "Расчетная сложность"
        static let realComplexity = "Реальная сложность"
    }

    enum Planning {
        static let pageTitle = "Планирование\nпоездки"
        static let enterRideTitle = "Введите название поездки"
        static let selectTime = "Выберите время поездки:"
        static let selectDate = "Выберите дату поездки:"
        static let selectTimeDuringRide = "Выберите время\nнахождения в поездке:"
        static let selectDistance = "Выберите длину маршрута:"
        static let save = "Сохранить"
    }

    enum History {
        static let pageTitle = "История"
    }

    enum Statistics {
        static let pageTitle = "Статистика"
        static let chart = "График километража за последние 5 поездок"
        static let recomendations = "Рекомендиции по поездкам"
        static let recomendedComplexity = "Рекомендованная сложность следующего маршрута: "
        static let moreRides = "Совершите больше поездок, чтобы увидеть ваши рекомендации по сложности"
    }
}
