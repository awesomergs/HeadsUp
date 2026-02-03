import Foundation

final class DeckPreferencesStore {
    private let deckKey = "deck_enabled_state"
    private let roundLengthKey = "round_length"
    private let favoriteCategoriesKey = "favorite_categories"

    // MARK: - Decks

    func loadDeckStates() -> [String: Bool] {
        guard
            let data = UserDefaults.standard.data(forKey: deckKey),
            let decoded = try? JSONDecoder().decode([String: Bool].self, from: data)
        else { return [:] }

        return decoded
    }

    func saveDeckStates(_ states: [String: Bool]) {
        guard let data = try? JSONEncoder().encode(states) else { return }
        UserDefaults.standard.set(data, forKey: deckKey)
    }

    // MARK: - Round Length

    func loadRoundLength(defaultValue: Int) -> Int {
        let value = UserDefaults.standard.integer(forKey: roundLengthKey)
        return value == 0 ? defaultValue : value
    }

    func saveRoundLength(_ value: Int) {
        UserDefaults.standard.set(value, forKey: roundLengthKey)
    }

    // MARK: - Favorite Categories

    func loadFavoriteCategories() -> Set<DeckCategory> {
        guard
            let rawValues = UserDefaults.standard.array(forKey: favoriteCategoriesKey) as? [String]
        else { return [] }

        return Set(rawValues.compactMap { DeckCategory(rawValue: $0) })
    }

    func saveFavoriteCategories(_ categories: Set<DeckCategory>) {
        let rawValues = categories.map { $0.rawValue }
        UserDefaults.standard.set(rawValues, forKey: favoriteCategoriesKey)
    }
}
