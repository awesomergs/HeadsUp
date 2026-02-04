import Foundation

struct Deck: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let category: DeckCategory
    let words: [String]
    var isEnabled: Bool = true
}
