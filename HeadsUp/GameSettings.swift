import Foundation

struct GameSettings {
    var roundLength: Int = 60
    var enabledDecks: [Deck] {
        decks.filter { $0.isEnabled }
    }

    var decks: [Deck]
}
