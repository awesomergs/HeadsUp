import UIKit

enum HapticType {
    case countdownTick
    case countdownGo
    case correct
    case wrong
    case finalSeconds
    case gameEnd
}

final class HapticsManager {
    static let shared = HapticsManager()
    private init() {}

    func play(_ type: HapticType) {
        switch type {
        case .countdownTick:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()

        case .countdownGo:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        case .correct:
            UINotificationFeedbackGenerator()
                .notificationOccurred(.success)

        case .wrong:
            UINotificationFeedbackGenerator()
                .notificationOccurred(.warning)

        case .finalSeconds:
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()

        case .gameEnd:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
}
