//
//  RideViewModel.swift
//

import SwiftUI

class RideViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var currentRide: RideInfoModel?
    @Published var isRideStarted: Bool = false
    @Published var totalAccumulatedTime: TimeInterval = 0
    @Published var cyclingStartTime: Date = .now

    // MARK: - Private Properties

    private weak var timer: Timer?

    private var previouslyAccumulatedTime: TimeInterval = 0

    // MARK: - Internal Functions

    func startRide() {
        isRideStarted = true 

        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
        )

        RunLoop.current.add(
            timer!,
            forMode: RunLoop.Mode.default
        )

        cyclingStartTime = .now

    }

    func endRide() {
        isRideStarted = false

        let accumulatedRunningTime = Date().timeIntervalSince(cyclingStartTime)

        previouslyAccumulatedTime += accumulatedRunningTime
        totalAccumulatedTime = previouslyAccumulatedTime

        timer!.invalidate()
        timer = nil

        previouslyAccumulatedTime = 0
        totalAccumulatedTime = 0
    }

    // MARK: - Private Functions

    @objc private func updateTimer() {
        totalAccumulatedTime = previouslyAccumulatedTime + Date().timeIntervalSince(cyclingStartTime)
    }
}
