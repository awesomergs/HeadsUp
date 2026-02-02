import Foundation

enum WordResult {
    case correct
    case pass
}

struct WordAttempt: Identifiable {
    let id = UUID()
    let word: String
    let result: WordResult
}
