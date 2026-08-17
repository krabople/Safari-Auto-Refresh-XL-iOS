import SafariServices
import AudioToolbox
import UserNotifications
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling, UNUserNotificationCenterDelegate {

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func beginRequest(with context: NSExtensionContext) {
        UNUserNotificationCenter.current().delegate = self
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey] as? [String: Any]

        os_log(.default, "Received native message from Safari extension: %@", String(describing: message))

        if let msg = message, let type = msg["type"] as? String {
            if type == "TARGET_DETECTED" || type == "PLAY_SOUND" || type == "SHOW_NOTIFICATION" {
                // 1. Play Physical iOS System Sound & Haptic Vibration
                AudioServicesPlayAlertSound(1005) // System Sound + Haptic Vibration
                AudioServicesPlayAlertSound(1007)
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)

                // 2. Request Notification Authorization & Post Local Notification Banner
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    let content = UNMutableNotificationContent()
                    content.title = "🎯 Auto Refresh XL - Target Detected!"
                    if let targetText = msg["targetText"] as? String, !targetText.isEmpty {
                        content.body = "Matched target: \"\(targetText)\" on your webpage!"
                    } else {
                        content.body = "Target keyword was detected on your webpage!"
                    }
                    content.sound = UNNotificationSound.defaultCritical

                    let request = UNNotificationRequest(
                        identifier: "target_\(Date().timeIntervalSince1970)",
                        content: content,
                        trigger: nil
                    )
                    center.add(request) { err in
                        if let err = err {
                            os_log(.error, "Error posting UNNotification: %@", err.localizedDescription)
                        } else {
                            os_log(.default, "Successfully posted UNNotification banner")
                        }
                    }
                }
            }
        }

        let response = NSExtensionItem()
        response.userInfo = [ SFExtensionMessageKey: [ "status": "success" ] ]
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
}
