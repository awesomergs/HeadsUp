import CoreMotion
import Foundation

final class MotionManager {

    private let manager = CMMotionManager()
    private let queue = OperationQueue()

    // Callbacks
    var onCorrect: (() -> Void)?
    var onPass: (() -> Void)?

    // Baseline (neutral holding angle)
    private var baselineRoll: Double?
    private let calibrationSamples = 10
    private var calibrationBuffer: [Double] = []

    // Debounce
    private var lastTriggerTime: Date = .distantPast
    private let debounceInterval: TimeInterval = 0.9

    // Tilt thresholds relative to baseline (≈ 35°)
    private let tiltThreshold: Double = 0.6

    func start() {
        guard manager.isDeviceMotionAvailable else { return }

        baselineRoll = nil
        calibrationBuffer.removeAll()
        lastTriggerTime = .distantPast

        manager.deviceMotionUpdateInterval = 0.1

        manager.startDeviceMotionUpdates(to: queue) { [weak self] motion, _ in
            guard
                let self,
                let roll = motion?.attitude.roll
            else { return }

            // Step 1: calibrate neutral position
            if self.baselineRoll == nil {
                self.calibrationBuffer.append(roll)

                if self.calibrationBuffer.count >= self.calibrationSamples {
                    self.baselineRoll =
                        self.calibrationBuffer.reduce(0, +) / Double(self.calibrationSamples)
                }

                return
            }

            // Step 2: compare against baseline
            let delta = roll - self.baselineRoll!

            let now = Date()
            guard now.timeIntervalSince(self.lastTriggerTime) > self.debounceInterval else {
                return
            }

            if delta < -self.tiltThreshold {
                self.lastTriggerTime = now
                self.onCorrect?()
            } else if delta > self.tiltThreshold {
                self.lastTriggerTime = now
                self.onPass?()
            }
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
        baselineRoll = nil
        calibrationBuffer.removeAll()
    }
}
