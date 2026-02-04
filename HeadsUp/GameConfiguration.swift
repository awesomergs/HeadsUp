import Foundation

struct GameConfiguration: Hashable {
    let roundLength: Int
    let decks: [Deck]
}
