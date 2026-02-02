import Foundation

final class DeckPreferencesStore {
    private let key = "deck_enabled_state"

    func load() -> [String: Bool] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let decoded = try? JSONDecoder().decode([String: Bool].self, from: data)
        else {
            return [:]
        }

        return decoded
    }

    func save(_ states: [String: Bool]) {
        guard let data = try? JSONEncoder().encode(states) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
