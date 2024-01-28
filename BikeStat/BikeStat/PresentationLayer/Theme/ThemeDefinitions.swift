//
//  ThemeDefinitions.swift
//

import Foundation
import SwiftUI

struct Theme1: Theme {
    var accentColor: Color = Pallete.accentColor
    var themeName: String = "Синяя светлая"
}

struct Theme2: Theme {
    var accentColor: Color = Pallete.accentColorForMap
    var themeName: String = "Синяя темная"
}

struct Theme3: Theme {
    var accentColor: Color = Pallete.oldAccentColor
    var themeName: String = "Фиолетовая"
}
