import CoreMotion
import Foundation

final class MotionManager {
    private let manager = CMMotionManager()
    private let queue = OperationQueue()

    var onTiltUp: (() -> Void)?
    var onTiltDown: (() -> Void)?

    private var lastTriggerTime: Date = .distantPast
    private let debounceInterval: TimeInterval = 1.0

    func start() {
        guard manager.isDeviceMotionAvailable else { return }

        manager.deviceMotionUpdateInterval = 0.2
        manager.startDeviceMotionUpdates(to: queue) { [weak self] motion, _ in
            guard
                let self,
                let pitch = motion?.attitude.pitch
            else { return }

            let now = Date()
            guard now.timeIntervalSince(self.lastTriggerTime) > self.debounceInterval else {
                return
            }

            if pitch > 0.8 {
                self.lastTriggerTime = now
                self.onTiltUp?()
            } else if pitch < -0.8 {
                self.lastTriggerTime = now
                self.onTiltDown?()
            }
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }
}
