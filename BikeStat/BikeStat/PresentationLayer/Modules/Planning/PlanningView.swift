//
//  PlanningView.swift
//

import SwiftUI

struct PlanningView: View {

    // MARK: - Property Wrappers

    @ObservedObject var planningViewModel: PlanningViewModel

    // MARK: - Body

    var body: some View {
        Text("Hello, World!")
    }
}

// MARK: - Preview

#Preview {
    PlanningView(
        planningViewModel: .init()
    )
}
