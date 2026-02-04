import Foundation
import Combine

@MainActor
final class GameViewModel: ObservableObject {


    @Published private(set) var session: GameSession
    @Published var isGameOver = false

    // Pre-round countdown
    @Published var preGameCountdown: Int? = 3
    @Published var isPreGameCountdownActive = true

    let allowsSwipeInput = true
    let allowsTiltInput = true

    private var gameTimer: AnyCancellable?
    private var countdownTimer: AnyCancellable?

    init(settings: GameSettings) {
        self.session = GameSession(
            duration: settings.roundLength,
            decks: settings.enabledDecks
        )
    }


    func startPreGameCountdown() {
        countdownTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tickPreGameCountdown()
            }
    }

    private func tickPreGameCountdown() {
        guard let value = preGameCountdown else { return }

        if value > 1 {
            preGameCountdown = value - 1
            HapticsManager.shared.play(.countdownTick)
        } else {
            countdownTimer?.cancel()
            preGameCountdown = nil
            isPreGameCountdownActive = false
            HapticsManager.shared.play(.countdownGo)
            startGame()
        }
    }


    private func startGame() {
        gameTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tickGame()
            }
    }

    private func tickGame() {
        session.tick()

        if session.remainingTime <= 3 && session.remainingTime > 0 {
            HapticsManager.shared.play(.finalSeconds)
        }

        if session.isOver {
            stop()
            HapticsManager.shared.play(.gameEnd)
            isGameOver = true
        }
    }

    func stop() {
        gameTimer?.cancel()
    }


    func markCorrect() {
        session.answerCurrentWord(.correct)
        HapticsManager.shared.play(.correct)
    }

    func markPass() {
        session.answerCurrentWord(.pass)
        HapticsManager.shared.play(.wrong)
    }
}
