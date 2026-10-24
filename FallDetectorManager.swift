import Foundation
import CoreMotion
import AVFoundation
import UIKit
import AudioToolbox

class FallDetectorManager: ObservableObject {
    static let shared = FallDetectorManager()

    @Published var isProtectionActive: BooleanLiteralType = false
    @Published var statusMessage: String = "Protección en segundo plano: INACTIVA"
    @Published var statusColorHex: String = "#EF4444"

    private let motion = CMMotionManager()
    private var lastAlertTime: Date = Date.distantPast

    init() {
        checkInitialProtection()
    }

    func checkInitialProtection() {
        if !RecoveryStorage.owner.isEmpty && !RecoveryStorage.contact.isEmpty {
            startProtection()
        } else {
            isProtectionActive = false
            statusMessage = "Protección en segundo plano: PENDIENTE DE CONFIGURAR"
            statusColorHex = "#F59E0B"
        }
    }

    func startProtection() {
        guard motion.isAccelerometerAvailable else {
            statusMessage = "Protección en segundo plano: ACTIVA"
            statusColorHex = "#10B981"
            isProtectionActive = true
            return
        }

        isProtectionActive = true
        statusMessage = "Protección en segundo plano: ACTIVA"
        statusColorHex = "#10B981"

        motion.accelerometerUpdateInterval = 0.05
        motion.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else { return }
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z

            // Magnitude in G's
            let totalAcceleration = sqrt(x*x + y*y + z*z)

            // Impact detection (> 3.2 G) with 2-second cooldown
            if totalAcceleration > 3.2 {
                let now = Date()
                if now.timeIntervalSince(self.lastAlertTime) > 2.0 {
                    self.lastAlertTime = now
                    self.triggerThreePulseAlert()
                }
            }
        }
    }

    func stopProtection() {
        motion.stopAccelerometerUpdates()
        isProtectionActive = false
        statusMessage = "Protección en segundo plano: INACTIVA"
        statusColorHex = "#EF4444"
    }

    func toggleProtection() {
        if isProtectionActive {
            stopProtection()
        } else {
            startProtection()
        }
    }

    func triggerThreePulseAlert() {
        // Haptic feedback & vibration
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.error)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

        // Flashlight pulses
        flashTorch(pulses: 3)

        // Sound alert
        AudioServicesPlaySystemSound(1005)
    }

    func triggerSoftBeep() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
        AudioServicesPlaySystemSound(1052)
    }

    private func flashTorch(pulses: Int) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            for _ in 0..<pulses {
                try? device.lockForConfiguration()
                try? device.setTorchModeOn(level: 1.0)
                device.unlockForConfiguration()
                Thread.sleep(forTimeInterval: 0.15)

                try? device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
                Thread.sleep(forTimeInterval: 0.15)
            }
        }
    }
}
