import Foundation

struct GameSession {
    let duration: Int
    private(set) var remainingTime: Int

    private(set) var words: [String]
    private(set) var currentWordIndex: Int

    private(set) var attempts: [WordAttempt] = []

    init(
        duration: Int,
        decks: [Deck],
        words: [String]? = nil,
        startIndex: Int = 0
    ) {
        self.duration = duration
        self.remainingTime = duration

        if let words {
            self.words = words
        } else {
            self.words = decks.flatMap { $0.words }.shuffled()
        }

        self.currentWordIndex = startIndex
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
}
