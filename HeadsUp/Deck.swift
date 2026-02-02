import Foundation

struct Deck: Identifiable, Codable {
    let id: String        
    let name: String
    let words: [String]
    var isEnabled: Bool = true
}
