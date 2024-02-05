//
//  NotificationManager.swift
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {

    // MARK: - Static Properties

    static let shared = NotificationManager()

    // MARK: - Inits

    private override init() {
        super.init()
    }

    // MARK: - Internal Functions

    func requestAuthorization() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: [.alert, .badge, .sound, .criticalAlert]
            ) { success, error in
                if let error {
                    print("DEBUG: \(error.localizedDescription)")
                }
            }

        UNUserNotificationCenter.current().delegate = self
    }

    func sendNotification(
        id: String = UUID().uuidString,
        title: String = "Поездка!",
        subtitle: String,
        date: Date
    ) {
        if shouldRequestAuthorization() {
            requestAuthorization()
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: date.makeDateComponents(),
            repeats: false
        )

        let request = makeRequest(id: id, trigger: trigger, content: content)

        UNUserNotificationCenter
            .current()
            .add(request) { error in
                if let error {
                    print("DEBUG: \(error.localizedDescription)")
                }
            }
    }

    func removeNotification(with id: String) {
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: [id])
    }

    func removeNotifications(with ids: [String]) {
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: ids)
    }

    // MARK: - Debug

    func removeAllNotifications() {
        UNUserNotificationCenter
            .current()
            .removeAllPendingNotificationRequests()
    }

    // MARK: - Private Functions

    private func makeRequest(
        id: String,
        trigger: UNCalendarNotificationTrigger,
        content: UNMutableNotificationContent
    ) -> UNNotificationRequest {
        .init(identifier: id, content: content, trigger: trigger)
    }

    private func shouldRequestAuthorization() -> Bool {
        var isNotificationEnabled = false

        UNUserNotificationCenter
            .current()
            .getNotificationSettings { status in
                switch status.authorizationStatus {
                case .denied, .ephemeral:
                    isNotificationEnabled = false
                case .authorized, .notDetermined, .provisional:
                    isNotificationEnabled = true
                @unknown default:
                    print("DEBUG: unowned notification status")
                }
            }

        return !isNotificationEnabled
    }
}
