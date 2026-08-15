import SafariServices
import AudioToolbox
import UserNotifications
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey] as? [String: Any]

        os_log(.default, "Received native message from Safari extension: %@", String(describing: message))

        if let msg = message, let type = msg["type"] as? String {
            if type == "TARGET_DETECTED" || type == "PLAY_SOUND" || type == "SHOW_NOTIFICATION" {
                // 1. Play Native iOS System Sound & Haptic Vibration on Physical Device
                AudioServicesPlayAlertSound(1005) // Standard iOS Alert Chime
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

                // 2. Post Native iOS Push Notification Banner
                let content = UNMutableNotificationContent()
                content.title = "🎯 Auto Refresh XL - Target Detected!"
                if let targetText = msg["targetText"] as? String, !targetText.isEmpty {
                    content.body = "Matched target: \"\(targetText)\" on your webpage!"
                } else {
                    content.body = "Target keyword was detected on your webpage!"
                }
                content.sound = UNNotificationSound.default

                let request = UNNotificationRequest(
                    identifier: "target_\(Date().timeIntervalSince1970)",
                    content: content,
                    trigger: nil
                )
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        os_log(.error, "Error posting UNNotification: %@", error.localizedDescription)
                    }
                }
            }
        }

        let response = NSExtensionItem()
        response.userInfo = [ SFExtensionMessageKey: [ "status": "success" ] ]
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
