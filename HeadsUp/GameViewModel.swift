import Foundation
import Combine

@MainActor
final class GameViewModel: ObservableObject {

    @Published private(set) var session: GameSession
    @Published var isGameOver = false

    // Pre-game countdown
    @Published var preGameCountdown: Int? = 3
    @Published var isPreGameCountdownActive = true

    let allowsSwipeInput = true
    let allowsTiltInput = true

    private let configuration: GameConfiguration
    private let carriedWords: [String]
    private let startIndex: Int

    private var gameTimer: AnyCancellable?
    private var countdownTimer: AnyCancellable?

    init(
        configuration: GameConfiguration,
        words: [String]? = nil,
        startIndex: Int = 0
    ) {
        self.configuration = configuration
        self.carriedWords = words ?? []
        self.startIndex = startIndex

        self.session = GameSession(
            duration: configuration.roundLength,
            decks: configuration.decks,
            words: words,
            startIndex: startIndex
        )
    }

    // MARK: - Pre-game Countdown

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

    // MARK: - Game Timer

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

    // MARK: - Answers

    func markCorrect() {
        session.answerCurrentWord(.correct)
        HapticsManager.shared.play(.correct)
    }

    func markPass() {
        session.answerCurrentWord(.pass)
        HapticsManager.shared.play(.wrong)
    }

    // MARK: - Replay Support

    func replayConfiguration() -> GameConfiguration {
        configuration
    }

    func replayWordState() -> (words: [String], index: Int) {
        (session.words, session.currentWordIndex)
    }
}
