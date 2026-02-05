import Foundation

enum DeckCategory: String, CaseIterable, Identifiable, Codable {
    case moviesAndTV
    case games
    case anime
    case general

    var id: String { rawValue }

    var title: String {
        switch self {
        case .moviesAndTV: return "Movies & TV"
        case .games: return "Games"
        case .anime: return "Anime"
        case .general: return "General"
        }
    }
}
