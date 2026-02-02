import Foundation
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    @Published private(set) var session: GameSession
    @Published var isGameOver = false

    // input toggles, so i could remove the swipe later if i feel so (lowk leaning towards keeping it tho)
    let allowsSwipeInput = true
    let allowsTiltInput = true

    private var timer: AnyCancellable?

    init(settings: GameSettings) {
        self.session = GameSession(
            duration: settings.roundLength,
            decks: settings.enabledDecks
        )
    }

    func start() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    func stop() {
        timer?.cancel()
    }

    func markCorrect() {
        session.answerCurrentWord(.correct)
    }

    func markPass() {
        session.answerCurrentWord(.pass)
    }

    private func tick() {
        session.tick()
        if session.isOver {
            stop()
            isGameOver = true
        }
    }
}
