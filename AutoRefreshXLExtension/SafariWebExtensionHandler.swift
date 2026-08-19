import SafariServices
import AudioToolbox
import UserNotifications
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling, UNUserNotificationCenterDelegate {

    func beginRequest(with context: NSExtensionContext) {
        guard let item = context.inputItems.first as? NSExtensionItem,
              let message = item.userInfo?[SFExtensionMessageKey] as? [String: Any],
              let type = message["type"] as? String,
              type == "TARGET_DETECTED" || type == "PLAY_SOUND" || type == "SHOW_NOTIFICATION" else {
            complete(context, success: false, error: "Invalid native alert request")
            return
        }

        os_log(.default, "Received native message from Safari extension: %@", String(describing: message))

        let shouldPlaySound = message["playSound"] as? Bool ?? true
        let shouldShowNotification = message["showNotification"] as? Bool ?? true

        if shouldPlaySound {
            AudioServicesPlayAlertSound(1005)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }

        guard shouldShowNotification else {
            complete(context, success: true)
            return
        }

        scheduleNotification(for: message, playSound: shouldPlaySound, context: context)
    }

    private func scheduleNotification(
        for message: [String: Any],
        playSound: Bool,
        context: NSExtensionContext
    ) {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                self.addNotification(
                    for: message,
                    playSound: playSound,
                    center: center,
                    context: context
                )

            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if let error = error {
                        self.complete(context, success: false, error: error.localizedDescription)
                    } else if granted {
                        self.addNotification(
                            for: message,
                            playSound: playSound,
                            center: center,
                            context: context
                        )
                    } else {
                        self.complete(context, success: false, error: "Notification permission was not granted")
                    }
                }

            case .denied:
                self.complete(context, success: false, error: "Notifications are disabled in iOS Settings")

            @unknown default:
                self.complete(context, success: false, error: "Unknown notification authorization status")
            }
        }
    }

    private func addNotification(
        for message: [String: Any],
        playSound: Bool,
        center: UNUserNotificationCenter,
        context: NSExtensionContext
    ) {
        let content = UNMutableNotificationContent()
        content.title = "🎯 Auto Refresh XL - Target Detected!"

        if let targetText = message["targetText"] as? String, !targetText.isEmpty {
            content.body = "Matched target: \"\(targetText)\" on your webpage!"
        } else {
            content.body = "Target keyword was detected on your webpage!"
        }

        // Critical sounds require an Apple-issued entitlement. The ordinary
        // default sound works with standard notification authorization.
        content.sound = playSound ? .default : nil

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "target_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        center.delegate = self

        center.add(request) { error in
            if let error = error {
                os_log(.error, "Error posting UNNotification: %@", error.localizedDescription)
                self.complete(context, success: false, error: error.localizedDescription)
            } else {
                os_log(.default, "Successfully posted UNNotification banner")
                self.complete(context, success: true)
            }
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }

    private func complete(_ context: NSExtensionContext, success: Bool, error: String? = nil) {
        var payload: [String: Any] = ["success": success]
        if let error = error {
            payload["error"] = error
        }

        let response = NSExtensionItem()
        response.userInfo = [SFExtensionMessageKey: payload]
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
