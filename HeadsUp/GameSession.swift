import Foundation

struct GameSession {
    let duration: Int
    private(set) var remainingTime: Int
    private(set) var words: [String]
    private(set) var currentWordIndex: Int = 0
    private(set) var attempts: [WordAttempt] = []

    init(duration: Int, decks: [Deck]) {
        self.duration = duration
        self.remainingTime = duration
        self.words = decks.flatMap { $0.words }.shuffled()
    }

    var currentWord: String {
        guard !words.isEmpty else { return "No Words" }
        return words[currentWordIndex % words.count]
    }

    mutating func answerCurrentWord(_ result: WordResult) {
        let attempt = WordAttempt(
            word: currentWord,
            result: result
        )
        attempts.append(attempt)
        currentWordIndex += 1
    }

    mutating func tick() {
        remainingTime -= 1
    }

    var isOver: Bool {
        remainingTime <= 0
    }

    var correctCount: Int {
        attempts.filter { $0.result == .correct }.count
    }

    var passCount: Int {
        attempts.filter { $0.result == .pass }.count
    }
}
