import SafariServices
import AudioToolbox

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems.first as? NSExtensionItem
        let message = item?.userInfo?[SFExtensionMessageKey] as? [String: Any]

        if message?["type"] as? String == "PLAY_ALERT_SOUND" {
            reply(to: context, payload: ["success": playAlertSound()])
            return
        }

        reply(to: context, payload: ["success": true])
    }

    private func reply(to context: NSExtensionContext, payload: [String: Any]) {
        let response = NSExtensionItem()
        response.userInfo = [SFExtensionMessageKey: payload]
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }

    private func playAlertSound() -> Bool {
        guard let soundURL = makeAlertSoundFile() else {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            return false
        }

        var soundID: SystemSoundID = 0
        guard AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID) == kAudioServicesNoError else {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            return false
        }

        let createdSoundID = soundID
        AudioServicesPlayAlertSoundWithCompletion(createdSoundID) {
            AudioServicesDisposeSystemSoundID(createdSoundID)
            try? FileManager.default.removeItem(at: soundURL)
        }
        return true
    }

    private func makeAlertSoundFile() -> URL? {
        let sampleRate: UInt32 = 11_025
        let duration = 0.55
        let sampleCount = Int(Double(sampleRate) * duration)
        var samples = Data(capacity: sampleCount)

        for index in 0..<sampleCount {
            let time = Double(index) / Double(sampleRate)
            let frequency = index < sampleCount / 2 ? 880.0 : 1_320.0
            let decay = 1.0 - Double(index) / Double(sampleCount)
            let value = 128.0 + sin(2.0 * Double.pi * frequency * time) * 105.0 * decay
            samples.append(UInt8(max(0, min(255, Int(value)))))
        }

        var wave = Data()
        wave.append(contentsOf: Array("RIFF".utf8))
        appendLittleEndian(UInt32(36 + sampleCount), to: &wave)
        wave.append(contentsOf: Array("WAVEfmt ".utf8))
        appendLittleEndian(UInt32(16), to: &wave)
        appendLittleEndian(UInt16(1), to: &wave)
        appendLittleEndian(UInt16(1), to: &wave)
        appendLittleEndian(sampleRate, to: &wave)
        appendLittleEndian(sampleRate, to: &wave)
        appendLittleEndian(UInt16(1), to: &wave)
        appendLittleEndian(UInt16(8), to: &wave)
        wave.append(contentsOf: Array("data".utf8))
        appendLittleEndian(UInt32(sampleCount), to: &wave)
        wave.append(samples)

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("auto-refresh-alert-\(UUID().uuidString).wav")
        do {
            try wave.write(to: url, options: .atomic)
            return url
        } catch {
            return nil
        }
    }

    private func appendLittleEndian<T: FixedWidthInteger>(_ value: T, to data: inout Data) {
        var littleEndianValue = value.littleEndian
        withUnsafeBytes(of: &littleEndianValue) { bytes in
            data.append(contentsOf: bytes)
        }
    }
}
