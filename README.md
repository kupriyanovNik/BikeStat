# **BikeStat 🚲**

![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Figma](https://img.shields.io/badge/figma-%23F24E1E.svg?style=for-the-badge&logo=figma&logoColor=white)

## Добро пожаловать в репозиторий!

### Описание
Наше приложение написано на [SwiftUI](https://developer.apple.com/xcode/swiftui/) и предназначено для устройств с операционной системой [iOS 16](https://ru.wikipedia.org/wiki/IOS_16) и новее. 
Оно предоставляет пользователям [удобный и интуитивно понятный интерфейс](https://www.figma.com/file/9rCteZ4QIBH2Uw3MMreihN/the-true-bikestat?type=design&node-id=441%3A1121&mode=design&t=SWfG9qbFdvQHJvIh-1) для отслеживания прогресса тренировок велосипедистов. 

### Основной функционал
- В приложении есть возможность планировать поездки заранее: пользователь может дать название поездке, выбрать дату и время начала, длину маршрута и желаемое время нахождения в пути. После сохранения запланированной поездки мы анализируем введенные данные и формируем **расчетную** сложность. 
- На протяжении поездки мы собираем такие данные, как расстояние, время в пути, скорость, пульс человека, на основе которых формируется **реальная** сложность. 
- После завершения поездки информация о ней **сохраняется** в базу данных [CoreData](https://developer.apple.com/documentation/coredata/) и отображается на экране истории поездок. Пользователь может посмотреть сохраненные данные, которые включают в себя название, дату и время, пройденное расстояние, время в пути, информацию о скорости и пульсе, затраченные калории, расчетную и реальную сложности.
- Приложение умеет давать пользователю **рекомендации о сложности** следующей поездки, основываясь на данных о предыдущих. Для отображения рекомендаций нужно совершить как минимум 3 поездки.

##### Наше приложение помогает велосипедистам эффективнее проводить тренировки и улучшать свои навыки!

### Управление проектом: [GitHub Projects](https://github.com/users/kupriyanovNik/projects/4)

### Особенности
- [Простой и понятный интерфейс](https://www.figma.com/file/9rCteZ4QIBH2Uw3MMreihN/the-true-bikestat?type=design&node-id=441%3A1121&mode=design&t=SWfG9qbFdvQHJvIh-1)
- Использование [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- Поддержка [iOS 16](https://ru.wikipedia.org/wiki/IOS_16) и выше
- Возможность выбрать цветовую гамму приложения и единицы измерения  

### Техническая информация 
- Архитектура: [MVVM](https://ru.wikipedia.org/wiki/Model-View-ViewModel)+S
- Локальное сохранение данных: [CoreData](https://developer.apple.com/documentation/coredata/)
- Сетевой слой на [async/await](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
- Карта: [MapKit](https://developer.apple.com/documentation/mapkit/)
- Unit-тестирование: [XCTest](https://developer.apple.com/documentation/xctest)

### Установка
Для установки приложения необходимо выполнить следующие шаги:

1. Скачать репозиторий на локальный компьютер
  - Открыть терминал
  - cd имя_папки_в_которую_нужно_скопировать
  - git clone https://github.com/kupriyanovNik/BikeStat.git
2. Открыть проект в [Xcode](https://developer.apple.com/xcode/)
  - поменять [BundleID](https://developer.apple.com/documentation/appstoreconnectapi/bundle_ids) на собственный
3. [Запустить проект на устройстве или симуляторе](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device)
  - cmd + shift + 2
  - добавить симулятор или физическое устройство
  - выбрать его как Run Destination
  - cmd + R

### Лицензия
Проект лицензирован в соответствии с условиями лицензии [LICENSE.md](https://github.com/kupriyanovNik/BikeStat/blob/develop/LICENSE).

### Контакты
Если у вас есть вопросы или предложения, пожалуйста, свяжитесь с нами:
- Почта [cucuprianov@gmail.com](mailto:cucuprianov@gmail.com) или [anfisochik@gmail.com](mailto:anfisochik@gmail.com)
- Telegram @idontknowktoya или @anfisochik
- Добавить [issue](https://github.com/kupriyanovNik/BikeStat/issues/new)
- Обсуждения [GitHub Discussions](https://github.com/kupriyanovNik/BikeStat/discussions)
